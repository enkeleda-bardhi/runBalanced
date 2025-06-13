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
  final double? avgBreath;
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
    this.avgBreath,
    this.avgJoints,
    this.avgMuscles,
  });
  factory TrainingSession.fromMap(
    Map<String, dynamic> map, {
    required String id,
  }) {
    // Extract dataSnapshots safely
    final List<Map<String, dynamic>>? dataSnapshots =
        map['dataSnapshots'] != null
            ? List<Map<String, dynamic>>.from(
              (map['dataSnapshots'] as List).map(
                (e) => Map<String, dynamic>.from(e as Map),
              ),
            )
            : null;

    // Helper to compute average of a key
    double computeAvg(String key) {
      if (dataSnapshots == null || dataSnapshots.isEmpty) return 0.0;
      return dataSnapshots
              .map((e) => (e[key] ?? 0) as num)
              .reduce((a, b) => a + b) /
          dataSnapshots.length;
    }

    return TrainingSession(
      id: id,
      time: map['time'] ?? '',
      distance: (map['distance'] as num).toDouble(),
      calories: (map['calories'] as num).toDouble(),
      statesPerKm: (map['statesPerKm'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ),
        ),
      ),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      dataSnapshots: dataSnapshots,
      avgPace: computeAvg('pace'),
      avgHeartRate: computeAvg('heartRate'),
      avgBreath: computeAvg('breath'),
      avgJoints: computeAvg('joints'),
      avgMuscles: computeAvg('muscles'),
    );
  }

  /// For saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'distance': distance,
      'calories': calories,
      'statesPerKm': statesPerKm.map(
        (key, value) => MapEntry(key, value.map((k, v) => MapEntry(k, v))),
      ),
      'timestamp': Timestamp.fromDate(timestamp),
      // Save dataSnapshots only if not null
      if (dataSnapshots != null) 'dataSnapshots': dataSnapshots,
    };
  }
}
