import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingSession {
  final String id;
  final String time;
  final double distance;
  final double calories;
  final Map<String, Map<String, double>> statesPerKm;
  final List<Map<String, dynamic>>? dataSnapshots;
  final DateTime timestamp;

  final double? avgPace;
  final double? avgHeartRate;
  final double? avgCardio;
  final double? avgJoints;
  final double? avgMuscles;

  TrainingSession({
    required this.id,
    required this.time,
    required this.distance,
    required this.calories,
    required this.statesPerKm,
    required this.dataSnapshots,
    required this.timestamp,
    this.avgPace,
    this.avgHeartRate,
    this.avgCardio,
    this.avgJoints,
    this.avgMuscles,
  });

  /// Extracts the list of joint fatigue data points for charting.
  List<double> getJointData() {
    final snapshots = dataSnapshots;
    if (snapshots == null || snapshots.isEmpty) return [];
    return snapshots.map((s) => (s['joints'] as num).toDouble()).toList();
  }

  /// Extracts the list of cardio fatigue data points for charting.
  List<double> getCardioData() {
    final snapshots = dataSnapshots;
    if (snapshots == null || snapshots.isEmpty) return [];
    return snapshots.map((s) => (s['cardio'] as num).toDouble()).toList();
  }

  /// Extracts the list of muscle fatigue (asymmetry) data points for charting.
  List<double> getMuscleData() {
    final snapshots = dataSnapshots;
    if (snapshots == null || snapshots.isEmpty) return [];
    return snapshots.map((s) => (s['muscles'] as num).toDouble()).toList();
  }

  /// Creates a copy of the session with a new ID. Useful after saving to Firestore.
  TrainingSession copyWith({String? id}) {
    return TrainingSession(
      id: id ?? this.id,
      time: time,
      distance: distance,
      calories: calories,
      statesPerKm: statesPerKm,
      dataSnapshots: dataSnapshots,
      timestamp: timestamp,
      avgPace: avgPace,
      avgHeartRate: avgHeartRate,
      avgCardio: avgCardio,
      avgJoints: avgJoints,
      avgMuscles: avgMuscles,
    );
  }

  factory TrainingSession.fromMap(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return TrainingSession(
      id: id,
      time: data['time'] ?? '00:00:00',
      distance: (data['distance'] as num?)?.toDouble() ?? 0.0,
      calories: (data['calories'] as num?)?.toDouble() ?? 0.0,
      statesPerKm: (data['statesPerKm'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as Map).map((k,v) => MapEntry(k.toString(), (v as num).toDouble())))
      ) ?? {},
      dataSnapshots: data['dataSnapshots'] != null ? List<Map<String, dynamic>>.from(data['dataSnapshots']) : null,
      // Read the pre-calculated averages directly from the data map.
      avgPace: (data['avgPace'] as num?)?.toDouble(),
      avgHeartRate: (data['avgHeartRate'] as num?)?.toDouble(),
      avgCardio: (data['avgCardio'] as num?)?.toDouble(),
      avgJoints: (data['avgJoints'] as num?)?.toDouble(),
      avgMuscles: (data['avgMuscles'] as num?)?.toDouble(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// For saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'distance': distance,
      'calories': calories,
      'statesPerKm': statesPerKm,
      'timestamp': Timestamp.fromDate(timestamp),
      // Add the average fields so they are saved to Firestore.
      'avgPace': avgPace,
      'avgHeartRate': avgHeartRate,
      'avgCardio': avgCardio,
      'avgJoints': avgJoints,
      'avgMuscles': avgMuscles,
      // Save dataSnapshots only if not null
      if (dataSnapshots != null) 'dataSnapshots': dataSnapshots,
    };
  }
}
