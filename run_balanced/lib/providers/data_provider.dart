import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:run_balanced/models/training_session.dart';
import 'package:run_balanced/models/exercise.dart';
import 'package:run_balanced/providers/user_profile_provider.dart';
import 'package:run_balanced/services/impact_api_service.dart';

class DataProvider extends ChangeNotifier {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  final UserProfileProvider userProfileProvider;
  DataProvider(this.userProfileProvider);

  bool _isLoading = false;

  double met = 9.8;
  double distance = 0.0;
  double calories = 0.0;
  double pace = 0.0;
  int heartRate = 0;

  double breathState = 0;
  double jointState = 0;
  double muscleState = 0;

  final List<double> breathBuffer = [];
  final List<double> jointBuffer = [];
  final List<double> muscleBuffer = [];
  final Map<int, Map<String, double>> statePerKm = {};

  final List<TrainingSession> savedSessions = [];
  final List<ExerciseSession> exerciseSessions = [];
  TrainingSession? lastSession;

  final List<Map<String, dynamic>> dataSnapshots = [];
  int _lastSnapshotSecond = 0;

  List<dynamic> _heartRateData = [];
  int _heartRateIndex = 0;

  List<dynamic> _calorieData = [];
  int _calorieIndex = 0;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
  }

  String get formattedTime {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  Future<void> startSimulation() async {
    _timer?.cancel();

    try {
      _heartRateData = await ImpactApiService.fetchHeartRateDay(
        day: DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.now().subtract(Duration(days: 2))),
      );
    } catch (e) {
      debugPrint("Heart rate API error: $e");
      _heartRateData = [];
    }

    try {
      _calorieData = await ImpactApiService.fetchCaloriesDay(
        day: DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.now().subtract(Duration(days: 2))),
      );
    } catch (e) {
      debugPrint("Calories API error: $e");
      _calorieData = [];
    }

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _elapsed += Duration(seconds: 1);

      final seconds = _elapsed.inSeconds;

      // Every 5 seconds: update pace, distance, vitals
      if (seconds % 5 == 0) {
        if (pace != 0) {
          final speedKmh = 60 / pace;
          distance += (speedKmh / 3600) * 5;
        }

        if (_heartRateIndex < _heartRateData.length) {
          final reading = _heartRateData[_heartRateIndex];
          heartRate = reading['value'] ?? heartRate;
          _heartRateIndex++;
        }

        if (_calorieIndex < _calorieData.length) {
          final reading = _calorieData[_calorieIndex];
          calories +=
              (double.tryParse(reading['value'].toString()) ?? 0.0) / 1000;
          _calorieIndex++;
        }

        const double minPace = 6.0; // fast jog
        const double maxPace = 12.0; // walk
        const int minHR = 50;
        const int maxHR = 180;

        final clampedHR = heartRate.clamp(minHR, maxHR);
        final normalizedHR = (clampedHR - minHR) / (maxHR - minHR);

        final fatigue = ((breathState + jointState + muscleState) / 3000).clamp(
          0.0,
          0.1,
        );

        double basePace = maxPace - normalizedHR * (maxPace - minPace);
        double variation = ([-0.5, -0.3, 0.0, 0.3, 0.5]..shuffle()).first;
        basePace = (basePace + variation).clamp(minPace, maxPace);

        final adjustedPace = (basePace * (1 + fatigue)).clamp(minPace, maxPace);
        pace = adjustedPace;

        final fatigueFactor = ((breathState + jointState + muscleState) / 1000)
            .clamp(0.0, 0.05);
        double baseSpeed = 3.0 + normalizedHR * 9.0;
        baseSpeed += variation;
        double adjustedSpeedKmh = baseSpeed * (1 - fatigueFactor);
        adjustedSpeedKmh = adjustedSpeedKmh.clamp(3.0, 12.0);
        pace = (adjustedSpeedKmh > 0) ? 60 / adjustedSpeedKmh : 0;

        final breathIncrement = ([0.1, 0.2, 0.3]..shuffle()).first;
        breathState = (breathState + breathIncrement).clamp(0, 90);

        final jointIncrement = ([0.1, 0.2, 0.3]..shuffle()).first;
        jointState = (jointState + jointIncrement).clamp(0, 85);

        final muscleIncrement = ([0.1, 0.2, 0.3]..shuffle()).first;
        muscleState = (muscleState + muscleIncrement).clamp(0, 90);

        breathBuffer.add(breathState);
        jointBuffer.add(jointState);
        muscleBuffer.add(muscleState);

        final currentKm = distance.floor();
        if (!statePerKm.containsKey(currentKm) && breathBuffer.isNotEmpty) {
          _saveKmAverage(currentKm);
        }

        if (seconds - _lastSnapshotSecond >= 5) {
          dataSnapshots.add({
            'time': seconds,
            'distance': distance,
            'calories': calories,
            'pace': pace,
            'heartRate': heartRate,
            'breath': breathState,
            'joints': jointState,
            'muscles': muscleState,
          });
          _lastSnapshotSecond = seconds;
        }
      }

      notifyListeners();
    });

    notifyListeners();
  }

  void _saveKmAverage(int km) {
    if (breathBuffer.isEmpty || jointBuffer.isEmpty || muscleBuffer.isEmpty)
      return;

    final avgBreath =
        breathBuffer.reduce((a, b) => a + b) / breathBuffer.length;
    final avgJoint = jointBuffer.reduce((a, b) => a + b) / jointBuffer.length;
    final avgMuscle =
        muscleBuffer.reduce((a, b) => a + b) / muscleBuffer.length;

    statePerKm[km] = {
      'breath': avgBreath,
      'joints': avgJoint,
      'muscles': avgMuscle,
    };

    breathBuffer.clear();
    jointBuffer.clear();
    muscleBuffer.clear();
  }

  void pauseSimulation() {
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _elapsed = Duration.zero;
    distance = 0.0;
    calories = 0.0;
    pace = 0.0;
    breathState = 0;
    jointState = 0;
    muscleState = 0;
    heartRate = 0;

    breathBuffer.clear();
    jointBuffer.clear();
    muscleBuffer.clear();
    statePerKm.clear();
    dataSnapshots.clear();
    _lastSnapshotSecond = 0;

    _heartRateData.clear();
    _heartRateIndex = 0;

    notifyListeners();
  }

  Future<TrainingSession?> save() async {
    if ((distance - distance.floor()) > 0.05 && breathBuffer.isNotEmpty) {
      _saveKmAverage(distance.floor() + 1);
    }

    final now = DateTime.now();
    final session = {
      'time': formattedTime,
      'distance': distance,
      'calories': calories,
      'statesPerKm': statePerKm.map((k, v) => MapEntry(k.toString(), v)),
      'dataSnapshots':
          dataSnapshots
              .map(
                (e) => {
                  'time': e['time'],
                  'distance': e['distance'],
                  'calories': e['calories'],
                  'pace': e['pace'],
                  'heartRate': e['heartRate'],
                  'breath': e['breath'],
                  'joints': e['joints'],
                  'muscles': e['muscles'],
                },
              )
              .toList(),
      'timestamp': Timestamp.fromDate(now),
    };

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final docRef = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('TrainingSessions')
            .add(session);

        final newSession = TrainingSession.fromMap(session, id: docRef.id);
        lastSession = newSession;
        savedSessions.add(newSession);
        notifyListeners();
      } else {
        throw Exception('No logged in user');
      }
    } catch (e) {
      debugPrint('Error saving training session: $e');
    }

    return lastSession;
  }

  Future<void> fetchTrainingSessions() async {
    _setLoading(true);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('TrainingSessions')
              .orderBy('timestamp', descending: true)
              .get();

      savedSessions.clear();
      for (final doc in snapshot.docs) {
        savedSessions.add(TrainingSession.fromMap(doc.data(), id: doc.id));
      }
      _setLoading(false);

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching training sessions: $e');
      _setLoading(false);
    }
  }

  Future<void> fetchAllSessions() async {
    _setLoading(true);
    try {
      // Fetch user-generated training sessions from Firebase
      await fetchTrainingSessions();

      // Fetch exercise sessions from the external API
      await fetchExerciseSessions();
    } catch (e) {
      debugPrint('Error fetching all sessions: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> fetchExerciseSessions() async {
    // Only fetch if the list is empty to avoid redundant API calls.
    if (exerciseSessions.isNotEmpty) {
      debugPrint('Exercise sessions already loaded. Skipping fetch.');
      return;
    }

    _setLoading(true);
    notifyListeners();

    try {
      debugPrint('Starting to fetch all historical exercise sessions...');
      await ImpactApiService.loadSettings();
      debugPrint('Settings loaded successfully.');

      final allFetchedSessions =
          await ImpactApiService.fetchAllExerciseSessions();

      debugPrint(
          'Total historical exercise sessions fetched: ${allFetchedSessions.length}');

      // Sort sessions by date, most recent first
      allFetchedSessions.sort((a, b) {
        final dateA = a.date ?? DateTime(1970);
        final dateB = b.date ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });

      exerciseSessions.clear();
      exerciseSessions.addAll(allFetchedSessions);
    } catch (e) {
      debugPrint('An error occurred in fetchAllExerciseSessions: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteSessionById(String id) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('TrainingSessions')
          .doc(id)
          .delete();

      savedSessions.removeWhere((session) => session.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting session: $e');
    }
  }

  void removeSession(int index) {
    savedSessions.removeAt(index);
    notifyListeners();
  }

  void togglePlayPause() {
    if (_timer?.isActive ?? false) {
      pauseSimulation();
    } else {
      startSimulation();
    }
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
