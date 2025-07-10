import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingSession {
  final String id;
  final String time;
  final double distance;
  final double calories;
  // Change the type to handle mixed int/double values from Firestore
  final Map<String, dynamic> statesPerKm;
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
  List<double?> getJointData() {
    final perKmData = statesPerKm['joints'] as Map<String, dynamic>? ?? {};
    if (perKmData.isEmpty) return [];
    final sortedKeys = perKmData.keys.map(int.parse).toList()..sort();
    return sortedKeys.map((k) => (perKmData[k.toString()] as num?)?.toDouble()).toList();
  }

  /// Extracts the list of cardio fatigue data points for charting.
  List<double?> getCardioData() {
    final perKmData = statesPerKm['cardio'] as Map<String, dynamic>? ?? {};
    if (perKmData.isEmpty) return [];
    final sortedKeys = perKmData.keys.map(int.parse).toList()..sort();
    return sortedKeys.map((k) => (perKmData[k.toString()] as num?)?.toDouble()).toList();
  }

  /// Extracts the list of muscle fatigue (asymmetry) data points for charting.
  List<double?> getMuscleData() {
    final perKmData = statesPerKm['muscles'] as Map<String, dynamic>? ?? {};
    if (perKmData.isEmpty) return [];
    final sortedKeys = perKmData.keys.map(int.parse).toList()..sort();
    return sortedKeys.map((k) => (perKmData[k.toString()] as num?)?.toDouble()).toList();
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

  factory TrainingSession.fromMap(Map<String, dynamic> map, {required String id}) {
    return TrainingSession(
      id: id,
      time: map['time'] ?? '00:00:00',
      distance: (map['distance'] as num? ?? 0.0).toDouble(),
      calories: (map['calories'] as num? ?? 0.0).toDouble(),
      // Ensure the map is parsed correctly
      statesPerKm: Map<String, dynamic>.from(map['statesPerKm'] ?? {}),
      dataSnapshots: map['dataSnapshots'] != null
          ? List<Map<String, dynamic>>.from(map['dataSnapshots'])
          : null,
      timestamp: (map['timestamp'] as Timestamp? ?? Timestamp.now()).toDate(),
      // Read the pre-calculated averages directly from the data map.
      avgPace: (map['avgPace'] as num?)?.toDouble(),
      avgHeartRate: (map['avgHeartRate'] as num?)?.toDouble(),
      avgCardio: (map['avgCardio'] as num?)?.toDouble(),
      avgJoints: (map['avgJoints'] as num?)?.toDouble(),
      avgMuscles: (map['avgMuscles'] as num?)?.toDouble(),
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
