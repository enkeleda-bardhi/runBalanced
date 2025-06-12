import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:run_balanced/providers/user_profile_provider.dart';

class DataProvider extends ChangeNotifier {
  // State
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  final UserProfileProvider userProfileProvider;
  DataProvider(this.userProfileProvider);

  double met = 9.8; // MET for running ~10 km/h
  double distance = 0.0; // km
  double calories = 0.0; // kcal
  double pace = 0.0; // min/km

  double breathState = 0;
  double jointState = 0;
  double muscleState = 0;

  // Buffer per second (to average every km)
  final List<double> breathBuffer = [];
  final List<double> jointBuffer = [];
  final List<double> muscleBuffer = [];

  // Map to save averages per km
  final Map<int, Map<String, double>> statePerKm = {};

  // Saved sessions
  final List<Map<String, dynamic>> savedSessions = [];
  Map<String, dynamic>? lastSession;

  // Time formatting hh:mm:ss
  String get formattedTime {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  void startSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _elapsed += Duration(seconds: 1);
      if (distance > 0) {
        pace = _elapsed.inSeconds / (60 * distance);
        if (pace.isNaN || pace.isInfinite || pace <= 0) {
          pace = 6.0; // safe default pace
        }
      } else {
        pace = 0.0; // avoid divide by zero
      }

      double speedKmh = 60 / pace;
      if (speedKmh.isNaN || speedKmh.isInfinite) {
        speedKmh = 10.0; // safe default speed
      }

      double distanceIncrement = speedKmh / 3600; // km per second
      if (distanceIncrement.isNaN || distanceIncrement.isInfinite) {
        distanceIncrement = 0.0;
      }

      distance += distanceIncrement;

      // Simulation (can be replaced with real data)
      double userWeightKg =
          userProfileProvider.weight > 0 ? userProfileProvider.weight : 70;
      double hoursElapsed = 1 / 3600; // 1 second in hours
      double caloriesIncrement = met * userWeightKg * hoursElapsed;
      calories += caloriesIncrement;

      // vary pace
      pace += ([-0.05, 0, 0.05]..shuffle()).first;
      if (pace < 4.0) pace = 4.0;
      if (pace > 8.0) pace = 8.0;

      breathState +=
          (pace > 6.0 ? 2 : 1) +
          (0.5 * (pace - 5.0)).clamp(0, 2) +
          ([-1, 0, 1]..shuffle()).first;
      breathState = breathState.clamp(0, 100);

      jointState +=
          (distance > 5 ? 1.5 : 1) +
          (0.2 * distance).clamp(0, 2) +
          ([-1, 0, 1]..shuffle()).first;
      jointState = jointState.clamp(0, 100);

      muscleState +=
          (distance > 3 ? 2 : 1) +
          (0.3 * distance).clamp(0, 2) +
          ([-1, 0, 1]..shuffle()).first;
      muscleState = muscleState.clamp(0, 100);

      // Add to buffer
      breathBuffer.add(breathState);
      jointBuffer.add(jointState);
      muscleBuffer.add(muscleState);

      // If a new km is reached, save averages
      final currentKm = distance.floor();
      if (!statePerKm.containsKey(currentKm) && breathBuffer.length >= 1) {
        _saveKmAverage(currentKm);
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

    breathBuffer.clear();
    jointBuffer.clear();
    muscleBuffer.clear();
    statePerKm.clear();
    notifyListeners();
  }

  Future<void> save() async {
    // If you're mid-way through a km, save a partial average
    final partialKm = distance - distance.floor();
    if (partialKm > 0.05 && breathBuffer.isNotEmpty) {
      _saveKmAverage(distance.floor() + 1);
    }
    final now = DateTime.now();
    final session = {
      'time': formattedTime,
      'distance': distance,
      'calories': calories,
      'pace': pace,
      'breath': breathState,
      'joints': jointState,
      'muscles': muscleState,
      'statesPerKm': statePerKm.map((k, v) => MapEntry(k.toString(), v)),
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

        session['id'] = docRef.id; // Optional: track document ID locally
        lastSession = session;
        savedSessions.add(session);
        notifyListeners();
      } else {
        throw Exception('No logged in user');
      }
    } catch (e) {
      debugPrint('Error saving training session: $e');
    }
  }

  Future<void> fetchTrainingSessions() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final snapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .collection('TrainingSessions')
                .orderBy('timestamp', descending: true)
                .get();

        savedSessions.clear();

        for (final doc in snapshot.docs) {
          final data = doc.data();
          data['id'] = doc.id;
          savedSessions.add(data);
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching training sessions: $e');
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

      savedSessions.removeWhere((session) => session['id'] == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting session: $e');
    }
  }

  void removeSession(int index) {
    savedSessions.removeAt(index);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
