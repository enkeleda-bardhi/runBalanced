import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingSession {
  final String id;
  final String time;
  final double distance;
  final double calories;
  final double pace;
  final double breath;
  final double joints;
  final double muscles;
  final Map<String, Map<String, double>> statesPerKm;
  final DateTime timestamp;

  /// New: List of rhythm snapshots, each is a map with time, km, rhythm values
  final List<Map<String, dynamic>>? rhythmSnapshots;

  TrainingSession({
    required this.id,
    required this.time,
    required this.distance,
    required this.calories,
    required this.pace,
    required this.breath,
    required this.joints,
    required this.muscles,
    required this.statesPerKm,
    required this.timestamp,
    this.rhythmSnapshots,
  });

  /// From Firestore map
  factory TrainingSession.fromMap(
    Map<String, dynamic> map, {
    required String id,
  }) {
    return TrainingSession(
      id: id,
      time: map['time'] ?? '',
      distance: (map['distance'] as num).toDouble(),
      calories: (map['calories'] as num).toDouble(),
      pace: (map['pace'] as num).toDouble(),
      breath: (map['breath'] as num).toDouble(),
      joints: (map['joints'] as num).toDouble(),
      muscles: (map['muscles'] as num).toDouble(),
      statesPerKm: (map['statesPerKm'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ),
        ),
      ),
      timestamp: (map['timestamp'] as Timestamp).toDate(),

      // Parse rhythmSnapshots if present, else null
      rhythmSnapshots:
          map['rhythmSnapshots'] != null
              ? List<Map<String, dynamic>>.from(
                (map['rhythmSnapshots'] as List).map(
                  (e) => Map<String, dynamic>.from(e as Map),
                ),
              )
              : null,
    );
  }

  /// For saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'distance': distance,
      'calories': calories,
      'pace': pace,
      'breath': breath,
      'joints': joints,
      'muscles': muscles,
      'statesPerKm': statesPerKm.map(
        (key, value) => MapEntry(key, value.map((k, v) => MapEntry(k, v))),
      ),
      'timestamp': Timestamp.fromDate(timestamp),
      // Save rhythmSnapshots only if not null
      if (rhythmSnapshots != null) 'rhythmSnapshots': rhythmSnapshots,
    };
  }
}
