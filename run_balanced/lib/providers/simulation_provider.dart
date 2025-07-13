import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:run_balanced/models/training_session.dart';
import 'package:run_balanced/models/exercise.dart';
import 'package:provider/provider.dart';
import 'package:run_balanced/providers/user_profile_provider.dart';
import 'package:run_balanced/services/impact_api_service.dart';
import 'package:run_balanced/providers/csv_loader.dart';
import 'package:run_balanced/models/asymmetry_index_model.dart';
import 'package:run_balanced/models/fatigue_cardio_model.dart';
import 'package:run_balanced/models/fatigue_joint_model.dart';
import 'package:run_balanced/utils/utilities.dart';

class SimulationProvider with ChangeNotifier {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  UserProfileProvider userProfileProvider;

  SimulationProvider(this.userProfileProvider) {
    fetchAllSessions();
  }

  void updateUserProfile(UserProfileProvider newUserProfileProvider) {
    userProfileProvider = newUserProfileProvider;
    notifyListeners();
  }

  bool _isLoading = false;

  // Simulation state variables
  double distance = 0.0;
  double calories = 0.0;
  double pace = 0.0;
  int heartRate = 0;
  double met = 8.0;

  // Fatigue state for UI - Renamed breathState to cardioState to match UI
  double cardioState = 0.0;
  double jointState = 0.0;
  double muscleState = 0.0;

  // Per-kilometer calculated fatigue data
  Map<int, double> jliLeftPerKm = {};
  Map<int, double> jliRightPerKm = {};
  Map<int, double> cardioFatiguePerKm = {};
  Map<int, double> asymmetryPerKm = {};

  // Data for saving session
  final List<Map<String, dynamic>> dataSnapshots = [];
  int _lastSnapshotSecond = 0;
  int _lastCompletedKm = 0;

  // Data loaded for simulation, kept in memory to allow resuming
  List<Map<String, dynamic>> _cardioSimData = [];
  List<Map<String, dynamic>> _biomechDataLeft = [];
  List<Map<String, dynamic>> _biomechDataRight = [];
  List<int> _hrList = [];
  int _maxTime = 0;
  int _hrIndex = 0;

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

  Future<void> _loadSimulationData() async {
    _setLoading(true);
    try {
      _cardioSimData = await loadCsvData('lib/assets/data/cardio_simulation.csv');
      _biomechDataLeft = await loadCsvData('lib/assets/data/biomech_simulation.csv');
      
      final random = Random();
      _biomechDataRight = _biomechDataLeft.map((e) {
        final newE = Map<String, dynamic>.from(e);
        final forceMultiplier = 1.0 + (random.nextDouble() * 0.1 - 0.05);
        final angleMultiplier = 1.0 + (random.nextDouble() * 0.1 - 0.05);
        final repMultiplier = 1.0 + (random.nextDouble() * 0.1 - 0.05);
        newE['F'] = (e['F'] as num? ?? 0) * forceMultiplier;
        newE['R'] = ((e['R'] as num? ?? 0) * repMultiplier).round();
        newE['theta'] = (e['theta'] as num? ?? 0) * angleMultiplier;
        return newE;
      }).toList();

      final heartRateApiData = await ImpactApiService.fetchHeartRateDay(
        day: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 2))),
      );
      _hrList = heartRateApiData.map((e) => (e['value'] as int)).toList();

      _maxTime = _cardioSimData.map((e) => e['time'] as num? ?? 0).reduce((a, b) => a > b ? a : b).toInt();

    } catch (e) {
      debugPrint("Error loading simulation data: $e");
    } finally {
      _setLoading(false);
    }
  }

  void _startTimer() {
    if (isPlaying) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_elapsed.inSeconds >= _maxTime) {
        stopSimulation();
        return;
      }

      _elapsed += const Duration(seconds: 1);
      final currentTime = _elapsed.inSeconds;

      final currentCardioPoint = _cardioSimData.firstWhere(
        (e) => (e['time'] as num? ?? 0) >= currentTime,
        orElse: () => _cardioSimData.last,
      );
      final currentBiomechPointLeft = _biomechDataLeft.firstWhere(
        (e) => (e['time'] as num? ?? 0) >= currentTime,
        orElse: () => _biomechDataLeft.last,
      );
      final currentBiomechPointRight = _biomechDataRight.firstWhere(
        (e) => (e['time'] as num? ?? 0) >= currentTime,
        orElse: () => _biomechDataRight.last,
      );

      distance = (currentCardioPoint['distance_km'] as num? ?? 0.0).toDouble();
      
      // Keep the new pace calculation
      
      if (distance > 0) {
        if ((_elapsed.inSeconds)%5 == 0) {
        pace = (_elapsed.inSeconds / 60.0) / distance;
        }
      } else {
        pace = 0.0;
      }

      if (_hrIndex < _hrList.length) {
        heartRate = _hrList[_hrIndex]*3; // Simulate heart rate doubling for testing
        _hrIndex++;
      }

      // Calculate MET based on heart rate
      if (heartRate < 100) {
        met = 6.0; // Light activity
      } else if (heartRate < 140) {
        met = 8.0; // Moderate activity
      } else {
        met = 10.0; // Vigorous activity
      } 

      if ((_elapsed.inSeconds)%5 == 0) {
        // Update heart rate every 5 seconds
        calories +=  met*0.0014*userProfileProvider.weight;
      }
     

      // --- PER-KILOMETER FATIGUE CALCULATION ---
      // Check if a new kilometer has been completed
      final int currentKm = distance.ceil();
      if (currentKm > 0 && currentKm > _lastCompletedKm) {
        // --- This block runs once per completed kilometer ---
        _lastCompletedKm = currentKm;

        // Create a lookup map for efficiency
        final timeToDistanceMap = {for (var e in _cardioSimData) (e['time'] as num) : (e['distance_km'] as num? ?? 0.0)};

        // Find all data points for the completed kilometer using the efficient lookup
        final biomechLeftForKm = _biomechDataLeft.where((e) {
            final distance = timeToDistanceMap[e['time'] as num? ?? 0] ?? 0.0;
            return distance.ceil() == currentKm;
        }).toList();
        final biomechRightForKm = _biomechDataRight.where((e) {
            final distance = timeToDistanceMap[e['time'] as num? ?? 0] ?? 0.0;
            return distance.ceil() == currentKm;
        }).toList();
        final cardioDataForKm = _cardioSimData.where((e) => (e['distance_km'] as num? ?? 0.0).ceil() == currentKm).toList();
        
        // Calculate and store fatigue for the completed kilometer
        jliLeftPerKm[currentKm] = _calculateJliForKm(biomechLeftForKm);
        jliRightPerKm[currentKm] = _calculateJliForKm(biomechRightForKm);
        cardioFatiguePerKm[currentKm] = _calculateCardioFatigueForKm(cardioDataForKm, _hrList, currentKm);
        
        final spo2ForKm = avg(cardioDataForKm.map((e) => (e['SpO2'] as num? ?? 0.0)).toList());
        asymmetryPerKm[currentKm] = asymmetryIndex(
          JLI_left: jliLeftPerKm[currentKm]!,
          JLI_right: jliRightPerKm[currentKm]!,
          SpO2: spo2ForKm,
        );
      }

      // --- INSTANT FATIGUE CALCULATION (for live UI) ---
      final double jliLeftInstant = calculateJLI(
        force: (currentBiomechPointLeft['F'] as num? ?? 0.0).toDouble(),
        angle: (currentBiomechPointLeft['theta'] as num? ?? 0.0).toDouble(),
        repetitions: (currentBiomechPointLeft['R'] as num? ?? 0).toInt(),
      );
      final double jliRightInstant = calculateJLI(
        force: (currentBiomechPointRight['F'] as num? ?? 0.0).toDouble(),
        angle: (currentBiomechPointRight['theta'] as num? ?? 0.0).toDouble(),
        repetitions: (currentBiomechPointRight['R'] as num? ?? 0).toInt(),
      );
      final double cardioFatigueInstant = calculateCardioFatigue(
        hr: heartRate,
        hrv: (currentCardioPoint['HRV'] as num? ?? 0.0).toDouble(),
        spo2: (currentCardioPoint['SpO2'] as num? ?? 0.0).toDouble(),
        bp: (currentCardioPoint['BP'] as num? ?? 0).toInt(),
        temp: (currentCardioPoint['Temp'] as num? ?? 0.0).toDouble(),
        distanceKm: distance,
      );
      final double asymmetryInstant = asymmetryIndex(
        JLI_left: jliLeftInstant,
        JLI_right: jliRightInstant,
        SpO2: (currentCardioPoint['SpO2'] as num? ?? 0.0).toDouble(),
      );

      jointState = (jliLeftInstant + jliRightInstant) / 2;
      cardioState = cardioFatigueInstant;
      muscleState = asymmetryInstant;

      if (currentTime - _lastSnapshotSecond >= 5) {
        _saveSnapshot(currentTime);
        _lastSnapshotSecond = currentTime;
      }

      notifyListeners();
    });
  }

  // Helper method to calculate JLI for a given kilometer's data
  double _calculateJliForKm(List<Map<String, dynamic>> biomechData) {
    if (biomechData.isEmpty) return 0.0;
    final jliValues = biomechData.map((e) => calculateJLI(
      force: (e['F'] as num? ?? 0.0).toDouble(),
      angle: (e['theta'] as num? ?? 0.0).toDouble(),
      repetitions: (e['R'] as num? ?? 0).toInt(),
    )).toList();
    return avg(jliValues);
  }

  // Helper method to calculate Cardio Fatigue for a given kilometer's data
  double _calculateCardioFatigueForKm(List<Map<String, dynamic>> cardioData, List<int> hrList, int km) {
    if (cardioData.isEmpty) return 0.0;

    final fatigueValues = cardioData.map((e) {
      final time = (e['time'] as num? ?? 0).toInt();
      final hr = (time < hrList.length) ? hrList[time] * 3 : 0; // Apply the same *3 logic for testing
      final pointDistance = (e['distance_km'] as num? ?? 0.0).toDouble(); // Get the actual distance for this point
      return calculateCardioFatigue(
        hr: hr,
        hrv: (e['HRV'] as num? ?? 0.0).toDouble(),
        spo2: (e['SpO2'] as num? ?? 0.0).toDouble(),
        bp: (e['BP'] as num? ?? 0).toInt(),
        temp: (e['Temp'] as num? ?? 0.0).toDouble(),
        distanceKm: pointDistance, // Use the actual distance
      );
    }).toList();

    return avg(fatigueValues);
  }

  void togglePlayPause() async {
    if (isPlaying) {
      pauseSimulation();
    } else {
      // If it's the very beginning, load data first.
      if (_elapsed == Duration.zero) {
        await _loadSimulationData();
      }
      // Start or resume the timer
      _startTimer();
    }
  }

  void _saveSnapshot(int currentTime) {
    dataSnapshots.add({
      'time': currentTime,
      'distance': distance,
      'calories': calories,
      'pace': pace,
      'heartRate': heartRate.toDouble(),
      'cardio': cardioState,
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
    cardioState = 0;
    jointState = 0;
    muscleState = 0;
    _hrIndex = 0;
    _lastCompletedKm = 0;

    jliLeftPerKm.clear();
    jliRightPerKm.clear();
    cardioFatiguePerKm.clear();
    asymmetryPerKm.clear();
    dataSnapshots.clear();
    _lastSnapshotSecond = 0;

    // Clear loaded data
    _cardioSimData.clear();
    _biomechDataLeft.clear();
    _biomechDataRight.clear();
    _hrList.clear();

    notifyListeners();
  }

  Future<TrainingSession?> save() async {
    final now = DateTime.now();
    final avgPace = avg(dataSnapshots.map((s) => (s['pace'] as num? ?? 0.0)).toList());
    final avgHeartRate = avg(dataSnapshots.map((s) => (s['heartRate'] as num? ?? 0.0)).toList());
    // Calculate averages from the per-kilometer data for consistency
    final avgCardio = avg(cardioFatiguePerKm.values.toList());
    final avgJoints = avg([...jliLeftPerKm.values, ...jliRightPerKm.values]);
    final avgMuscles = avg(asymmetryPerKm.values.toList());

    final session = {
      'time': formattedTime,
      'distance': distance,
      'calories': calories,
      'avgPace': avgPace,
      'avgHeartRate': avgHeartRate,
      'avgCardio': avgCardio,
      'avgJoints': avgJoints,
      'avgMuscles': avgMuscles,
      'dataSnapshots': dataSnapshots,
      'timestamp': Timestamp.fromDate(now),
      'statesPerKm': {
        'joints': jliLeftPerKm.map((key, value) => MapEntry(key.toString(), value)),
        'cardio': cardioFatiguePerKm.map((key, value) => MapEntry(key.toString(), value)),
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
        savedSessions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
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
  

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> start(BuildContext context) async {
    if (isPlaying) return;

    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    if (!userProfileProvider.isLoaded) {
      await userProfileProvider.loadUserProfile();
    }

    // Load simulation data files
    await _loadSimulationData();

    // Start or resume the timer
    _startTimer();
  }
}