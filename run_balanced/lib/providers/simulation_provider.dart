import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:run_balanced/models/training_session.dart';
import 'package:run_balanced/models/exercise.dart';
import 'package:run_balanced/providers/user_profile_provider.dart';
import 'package:run_balanced/services/impact_api_service.dart';
import 'package:run_balanced/models/asymmetry_index_model.dart';
import 'package:run_balanced/models/fatigue_cardio_model.dart';
import 'package:run_balanced/models/fatigue_joint_model.dart';
import 'package:run_balanced/providers/csv_loader.dart';

class DataProvider extends ChangeNotifier {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  final UserProfileProvider userProfileProvider;
  DataProvider(this.userProfileProvider);

  bool _isLoading = false;
  double distance = 0.0;
  double calories = 0.0;
  double met = 8.0; // MET value for running at 8 km/h
  int heartRate = 0;

  List<dynamic> _heartRateData = [];
  int _heartRateIndex = 0;

  final List<dynamic> _calorieData = [];
  final int _calorieIndex = 0;

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

   // New state for fatigue indexes
  Map<int, double> jliLeftPerKm = {};
  Map<int, double> jliRightPerKm = {};
  Map<int, int> cardioFatiguePerKm = {};
  Map<int, double> asymmetryPerKm = {};

  // State variables for simulation
  double jointState = 0.0;
  double breathState = 0.0;
  double muscleState = 0.0;

  // Buffers for averaging (if used elsewhere)
  List<double> breathBuffer = [];
  List<double> jointBuffer = [];
  List<double> muscleBuffer = [];

  Future<void> startSimulation() async {
    _timer?.cancel();
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Load data from CSV files
      final cardioData = await loadCsvData('lib/assets/data/cardio_simulation.csv');
      final biomechDataLeft = await loadCsvData('lib/assets/data/biomech_simulation.csv');
      
      // Create slightly different data for the right side to show asymmetry
      final biomechDataRight = biomechDataLeft.map((e) {
        final newE = Map<String, dynamic>.from(e);
        newE['F'] = (e['F'] as double) * 1.05; // 5% more force
        return newE;
      }).toList();

      // Fetch real heart rate data to be used in cardio fatigue calculation
      _heartRateData = await ImpactApiService.fetchHeartRateDay(
        day: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 2))),
      );
      final hrList = _heartRateData.map((e) => (e['value'] as int)).toList();

      // 2. Calculate fatigue indexes per kilometer
      jliLeftPerKm = calculateJLIperKm(biomechDataLeft);
      jliRightPerKm = calculateJLIperKm(biomechDataRight);
      cardioFatiguePerKm = calculateCardioFatiguePerKm(cardioData, hrList);
      asymmetryPerKm = asymmetryIndex_km(JLI_left: jliLeftPerKm, JLI_right: jliRightPerKm);

      // double jliLeft = calculateJLI(biomechDataLeft.forza, angle: biomechDataLeft.theta, repetitions: biomechDataLeft.R as int);
      // double jliRight = calculateJLI(biomechDataRight.forza, angle: biomechDataRight.theta, repetitions: biomechDataRight.R as int);
      // double cardioFatigue = calculateCardioFatigue(cardioData, hrList);
      // double asymmetry = asymmetryIndex(JLI_left: jliLeft, JLI_right: jliRight);

      // 3. Simulate the run based on cardio data
      int maxTime = cardioData.map((e) => e['time'] as int).reduce((a, b) => a > b ? a : b);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_elapsed.inSeconds >= maxTime) {
          timer.cancel();
          _setLoading(false);
          notifyListeners();
          return;
        }

        _elapsed += const Duration(seconds: 1);
        final currentTime = _elapsed.inSeconds;

        // Find the closest data point in cardio data
        final currentData = cardioData.firstWhere(
          (e) => (e['time'] as int) >= currentTime,
          orElse: () => cardioData.last,
        );

        //distance = cardioData['distanceKm']; 
        if (_heartRateIndex < _heartRateData.length) {
          heartRate = _heartRateData[_heartRateIndex]['value'];
          _heartRateIndex++;
        }

        // Simple calorie simulation
        // prendere calorie da impact
        calories += (met * 3.5 * (userProfileProvider.weight)) / (200 * 60);

        // Update states for UI
        jointState = (jliLeftPerKm[distance.floor()] ?? 0.0);
        breathState = (cardioFatiguePerKm[distance.floor()] ?? 0.0).toDouble();
        muscleState = (asymmetryPerKm[distance.floor()] ?? 0.0);

        notifyListeners();
      });
    } catch (e) {
      debugPrint("Error during simulation setup: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}