import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:run_balanced/models/training_session.dart';
import 'package:run_balanced/models/exercise.dart';
import 'package:run_balanced/providers/user_profile_provider.dart';
import 'package:run_balanced/services/impact_api_service.dart';
import 'package:run_balanced/providers/csv_loader.dart';
import 'package:run_balanced/models/asymmetry_index_model.dart';
import 'package:run_balanced/models/fatigue_cardio_model.dart';
import 'package:run_balanced/models/fatigue_joint_model.dart';

class DataProvider with ChangeNotifier {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  UserProfileProvider userProfileProvider;

  DataProvider(this.userProfileProvider) {
    // Fetch all sessions as soon as the provider is created.
    // This ensures data is ready for any screen that needs it.
    fetchAllSessions();
  }
void updateUserProfile(UserProfileProvider newUserProfileProvider) {
    // Update the internal reference to the user profile provider.
    userProfileProvider = newUserProfileProvider;
    
    // Notify listeners that DataProvider has been updated.
    // You can add any logic here that should run when the user profile changes.
    notifyListeners();
  }
  bool _isLoading = false;

  // Simulation state variables
  double distance = 0.0;
  double calories = 0.0;
  double pace = 0.0;
  int heartRate = 0;
  double met = 8.0; // MET value for running, can be adjusted

  // Fatigue state for UI
  double breathState = 0.0;
  double jointState = 0.0;
  double muscleState = 0.0;

  // Per-kilometer calculated fatigue data
  Map<int, double> jliLeftPerKm = {};
  Map<int, double> jliRightPerKm = {};
  Map<int, int> cardioFatiguePerKm = {};
  Map<int, double> asymmetryPerKm = {};

  // Data for saving session
  final List<Map<String, dynamic>> dataSnapshots = [];
  int _lastSnapshotSecond = 0;

  // Other provider state
  final List<TrainingSession> savedSessions = [];
  final List<ExerciseSession> exerciseSessions = [];
  TrainingSession? lastSession;

  bool get isLoading => _isLoading;
  bool get isPlaying => _timer?.isActive ?? false;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String get formattedTime {
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  /// Starts the training simulation using data from CSV files and fatigue models.
  Future<void> startSimulation() async {
    if (_timer?.isActive ?? false) return; // Already running

    _setLoading(true);

    try {
      // 1. Load all necessary data for the simulation
      final cardioSimData = await loadCsvData('lib/assets/data/cardio_simulation.csv');
      final biomechDataLeft = await loadCsvData('lib/assets/data/biomech_simulation.csv');
      
      final random = Random();

      // Create slightly different data for the right side to simulate asymmetry
      final biomechDataRight = biomechDataLeft.map((e) {
        final newE = Map<String, dynamic>.from(e);
        final forceMultiplier = 1.0 + (random.nextDouble() * 0.1 - 0.05);
        final angleMultiplier = 1.0 + (random.nextDouble() * 0.1 - 0.05);
        final repMultiplier = 1.0 + (random.nextDouble() * 0.1 - 0.05);

        // Use null-aware operators with default values to prevent errors
        newE['F'] = (e['F'] as num? ?? 0) * forceMultiplier;
        newE['R'] = ((e['R'] as num? ?? 0) * repMultiplier).round();
        newE['theta'] = (e['theta'] as num? ?? 0) * angleMultiplier;
        return newE;
      }).toList();

      // Fetch real heart rate data to be used in cardio fatigue calculation
      final heartRateApiData = await ImpactApiService.fetchHeartRateDay(
        day: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 2))),
      );
      // Filter out nulls and safely cast heart rate values.
      final hrList = heartRateApiData
          .map((e) => e['value'] as int?)
          .where((v) => v != null)
          .cast<int>()
          .toList();

      // 2. Pre-calculate fatigue indexes for each kilometer
      // The exact implementation of these functions is not visible, but ensure they handle
      // null values safely when processing the data lists. For example, when accessing
      // e['F'], e['R'], e['theta'], etc., use `(e['key'] as num? ?? 0)`
      jliLeftPerKm = calculateJLIperKm(biomechDataLeft, cardioSimData);
      jliRightPerKm = calculateJLIperKm(biomechDataRight, cardioSimData);
      
      cardioFatiguePerKm = calculateCardioFatiguePerKm(cardioSimData, hrList);
      asymmetryPerKm = asymmetryIndex_km(JLI_left: jliLeftPerKm, JLI_right: jliRightPerKm);

      // 3. Start the timer to simulate the run second-by-second
      // Safely get the max time, defaulting to 0 if the list is empty or contains nulls.
      int maxTime = cardioSimData
          .map((e) => e['time'] as num? ?? 0)
          .cast<int>()
          .fold(0, (max, current) => current > max ? current : max);
      int hrIndex = 0;

      _setLoading(false);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_elapsed.inSeconds >= maxTime) {
          stopSimulation();
          return;
        }

        _elapsed += const Duration(seconds: 1);
        final currentTime = _elapsed.inSeconds;

        // Find the closest data point in the simulation data for the current time
        final currentCardioPoint = cardioSimData.firstWhere(
          (e) => (e['time'] as int) >= currentTime,
          orElse: () => cardioSimData.last,
        );
        final currentBiomechPointLeft = biomechDataLeft.firstWhere(
          (e) => (e['time'] as int) >= currentTime,
          orElse: () => biomechDataLeft.last,
        );
        final currentBiomechPointRight = biomechDataRight.firstWhere(
          (e) => (e['time'] as int) >= currentTime,
          orElse: () => biomechDataRight.last,
        );

        // Update main metrics from simulation data
        distance = (currentCardioPoint['distance_km'] as num? ?? 0).toDouble();
        pace = (currentCardioPoint['pace_min_km'] as num? ?? 0).toDouble();
        if (hrIndex < hrList.length) {
          heartRate = hrList[hrIndex];
          hrIndex++;
        }

        // Calculate calories burned
        // Use a default weight if the profile hasn't loaded, to prevent crashes.
        final userWeight = userProfileProvider.isLoaded ? userProfileProvider.weight : 75.0;
        calories += (met * 3.5 * userWeight) / (200 * 60);

        // --- INSTANT FATIGUE CALCULATION ---
        
        // Calculate instant Joint Load Index (JLI) with safe casting
        final double jliLeftInstant = calculateJLI(
          force: (currentBiomechPointLeft['F'] as num? ?? 0).toDouble(),
          angle: (currentBiomechPointLeft['theta'] as num? ?? 0).toDouble(),
          repetitions: (currentBiomechPointLeft['R'] as num? ?? 0).toInt(),
        );
        final double jliRightInstant = calculateJLI(
          force: (currentBiomechPointRight['F'] as num? ?? 0).toDouble(),
          angle: (currentBiomechPointRight['theta'] as num? ?? 0).toDouble(),
          repetitions: (currentBiomechPointRight['R'] as num? ?? 0).toInt(),
        );

        // Calculate instant Cardio Fatigue
        final int cardioFatigueInstant = calculateCardioFatigue(
          hr: heartRate,
          hrv: (currentCardioPoint['HRV'] as num?)?.toDouble() ?? 0.0, // Safe access with default value
          spo2: (currentCardioPoint['SpO2'] as num?)?.toDouble() ?? 0.0, // Safe access with default value
          bp: (currentCardioPoint['BP'] as num?)?.toInt() ?? 0, // Safe access with default value
          temp: (currentCardioPoint['Temp'] as num?)?.toDouble() ?? 0.0, // Safe access with default value
          distanceKm: distance,
        );

        // Calculate instant Asymmetry
        final double asymmetryInstant = asymmetryIndex(
          JLI_left: jliLeftInstant,
          JLI_right: jliRightInstant,
        );

        // Update UI state variables with instant values
        jointState = (jliLeftInstant + jliRightInstant) / 2;
        breathState = cardioFatigueInstant.toDouble();
        muscleState = asymmetryInstant;
        // --- END OF INSTANT CALCULATION ---

        // Save a snapshot of the current state at intervals
        if (currentTime - _lastSnapshotSecond >= 5) {
          _saveSnapshot(currentTime);
          _lastSnapshotSecond = currentTime;
        }

        notifyListeners();
      });
    } catch (e) {
      debugPrint("Error during simulation setup: $e");
      _setLoading(false);
    }
  }

  void _saveSnapshot(int currentTime) {
    dataSnapshots.add({
      'time': currentTime,
      'distance': distance,
      'calories': calories,
      'pace': pace,
      'heartRate': heartRate.toDouble(),
      'breath': breathState,
      'joints': jointState,
      'muscles': muscleState,
    });
    

  }

  void pauseSimulation() {
    _timer?.cancel();
    notifyListeners();
  }

  void stopSimulation() {
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _elapsed = Duration.zero;
    distance = 0.0;
    calories = 0.0;
    pace = 0.0;
    heartRate = 0;
    breathState = 0;
    jointState = 0;
    muscleState = 0;

    jliLeftPerKm.clear();
    jliRightPerKm.clear();
    cardioFatiguePerKm.clear();
    asymmetryPerKm.clear();
    dataSnapshots.clear();
    _lastSnapshotSecond = 0;

    notifyListeners();
  }

  Future<TrainingSession?> save() async {
    final now = DateTime.now();
    // Calculate average states from snapshots
    final avgPace = dataSnapshots.isNotEmpty ? dataSnapshots.map((s) => s['pace'] as num? ?? 0.0).reduce((a, b) => a + b) / dataSnapshots.length : 0.0;
    final avgHeartRate = dataSnapshots.isNotEmpty ? dataSnapshots.map((s) => s['heartRate'] as num? ?? 0.0).reduce((a, b) => a + b) / dataSnapshots.length : 0.0;
    final avgBreath = dataSnapshots.isNotEmpty ? dataSnapshots.map((s) => s['breath'] as num? ?? 0.0).reduce((a, b) => a + b) / dataSnapshots.length : 0.0;
    final avgJoints = dataSnapshots.isNotEmpty ? dataSnapshots.map((s) => s['joints'] as num? ?? 0.0).reduce((a, b) => a + b) / dataSnapshots.length : 0.0;
    final avgMuscles = dataSnapshots.isNotEmpty ? dataSnapshots.map((s) => s['muscles'] as num? ?? 0.0).reduce((a, b) => a + b) / dataSnapshots.length : 0.0;

    final session = {
      'time': formattedTime,
      'distance': distance,
      'calories': calories,
      'avgPace': avgPace,
      'avgHeartRate': avgHeartRate,
      'avgBreath': avgBreath,
      'avgJoints': avgJoints,
      'avgMuscles': avgMuscles,
      'dataSnapshots': dataSnapshots,
      'timestamp': Timestamp.fromDate(now),
      'statesPerKm': {
        'joints': jliLeftPerKm.map((key, value) => MapEntry(key.toString(), value)),
        'breath': cardioFatiguePerKm.map((key, value) => MapEntry(key.toString(), value)),
        'muscles': asymmetryPerKm.map((key, value) => MapEntry(key.toString(), value)),
      },
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
        return newSession;
      } else {
        throw Exception('No logged in user');
      }
    } catch (e) {
      debugPrint('Error saving training session: $e');
      return null;
    }
  }

  Future<void> fetchTrainingSessions() async {
    _setLoading(true);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _setLoading(false);
      return;
    }

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
    } catch (e) {
      debugPrint('Error fetching training sessions: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllSessions() async {
    _setLoading(true);
    try {
      await fetchTrainingSessions();
      await fetchExerciseSessions();
    } catch (e) {
      debugPrint('Error fetching all sessions: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchExerciseSessions() async {
    if (exerciseSessions.isNotEmpty) return;

    _setLoading(true);
    try {
      await ImpactApiService.loadSettings();
      final allFetchedSessions = await ImpactApiService.fetchAllExerciseSessions();
      allFetchedSessions.sort((a, b) => (b.date ?? DateTime(1970)).compareTo(a.date ?? DateTime(1970)));
      exerciseSessions.clear();
      exerciseSessions.addAll(allFetchedSessions);
    } catch (e) {
      debugPrint('An error occurred in fetchAllExerciseSessions: $e');
    } finally {
      _setLoading(false);
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

  void togglePlayPause() {
    if (_timer?.isActive ?? false) {
      pauseSimulation();
    } else {
      startSimulation();
    }
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}