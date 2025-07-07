import 'package:flutter/foundation.dart';

// Helper functions for robust JSON parsing
double? _safeParseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _safeParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

class ExerciseResponse {
  final String status;
  final int code;
  final String message;
  final ExerciseData data;

  ExerciseResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ExerciseResponse.fromJson(Map<String, dynamic> json) {
    final date = json['date']?.toString();
    return ExerciseResponse(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: ExerciseData.fromJson(json['data'], date: date),
    );
  }
}

class ExerciseData {
  final String? date;
  final List<ExerciseSession> sessions;

  ExerciseData({
    this.date,
    required this.sessions,
  });

  factory ExerciseData.fromJson(Map<String, dynamic> json, {String? date}) {
    final List<ExerciseSession> sessions = [];
    if (json['data'] is List) {
      for (var sessionJson in (json['data'] as List)) {
        try {
          sessions.add(ExerciseSession.fromJson(sessionJson, date: date ?? json['date']?.toString()));
        } catch (e) {
          debugPrint('Failed to parse an exercise session: $e');
        }
      }
    }
    
    return ExerciseData(
      date: date ?? json['date']?.toString(),
      sessions: sessions,
    );
  }
}

class ExerciseSession {
  final String? logId;
  final String? activityName;
  final String? activityTypeId;
  final List<ActivityLevel>? activityLevel;
  final int? averageHeartRate;
  final double? calories;
  final double? distance;
  final String? distanceUnit;
  final double? duration;
  final int? activeDuration;
  final double? durationInSeconds; // Add this field
  final int? steps;
  final ExerciseSource? source;
  final String? logType;
  final ManualValuesSpecified? manualValuesSpecified;
  final String? tcxLink;
  final List<HeartRateZone>? heartRateZones;
  final ActiveZoneMinutes? activeZoneMinutes;
  final double? speed;
  final double? pace;
  final Vo2Max? vo2Max;
  final double? elevationGain;
  final bool? hasGps;
  final bool? shouldFetchDetails;
  final bool? hasActiveZoneMinutes;
  final String? time;
  final DateTime? date; // Add date field

  ExerciseSession({
    this.logId,
    this.activityName,
    this.activityTypeId,
    this.activityLevel,
    this.averageHeartRate,
    this.calories,
    this.distance,
    this.distanceUnit,
    this.duration,
    this.activeDuration,
    this.durationInSeconds, // Add this
    this.steps,
    this.source,
    this.logType,
    this.manualValuesSpecified,
    this.tcxLink,
    this.heartRateZones,
    this.activeZoneMinutes,
    this.speed,
    this.pace,
    this.vo2Max,
    this.elevationGain,
    this.hasGps,
    this.shouldFetchDetails,
    this.hasActiveZoneMinutes,
    this.time,
    this.date,
  });

  factory ExerciseSession.fromJson(Map<String, dynamic> json, {required String? date}) {
    String? timeStr = json['time']?.toString();
    DateTime? parsedDateTime;

    if (date != null && timeStr != null) {
      try {
        parsedDateTime = DateTime.parse('${date}T$timeStr');
      } catch (e) {
        debugPrint('Could not parse date/time for session: $date $timeStr');
      }
    }

    final durationInMillis = _safeParseInt(json['duration']);
    final duration = durationInMillis != null ? durationInMillis / 1000.0 : null;

    return ExerciseSession(
      logId: json['logId']?.toString(),
      activityName: json['activityName']?.toString() ?? 'Unknown Activity',
      activityTypeId: json['activityTypeId']?.toString(),
      activityLevel: (json['activityLevel'] is List)
          ? (json['activityLevel'] as List)
              .map((level) => ActivityLevel.fromJson(level))
              .toList()
          : [],
      averageHeartRate: _safeParseInt(json['averageHeartRate']),
      calories: _safeParseDouble(json['calories']),
      distance: _safeParseDouble(json['distance']),
      distanceUnit: json['distanceUnit']?.toString(),
      activeDuration: _safeParseInt(json['activeDuration']),
      duration: duration,
      steps: _safeParseInt(json['steps']),
      source: (json['source'] is Map<String, dynamic>)
          ? ExerciseSource.fromJson(json['source'])
          : null,
      logType: json['logType']?.toString(),
      manualValuesSpecified: (json['manualValuesSpecified'] is Map<String, dynamic>)
          ? ManualValuesSpecified.fromJson(json['manualValuesSpecified'])
          : null,
      tcxLink: json['tcxLink']?.toString(),
      heartRateZones: (json['heartRateZones'] is List)
          ? (json['heartRateZones'] as List)
              .map((zone) => HeartRateZone.fromJson(zone))
              .toList()
          : null,
      activeZoneMinutes: (json['activeZoneMinutes'] is Map<String, dynamic>)
          ? ActiveZoneMinutes.fromJson(json['activeZoneMinutes'])
          : null,
      speed: _safeParseDouble(json['speed']),
      pace: _safeParseDouble(json['pace']),
      vo2Max: (json['vo2Max'] is Map<String, dynamic>)
          ? Vo2Max.fromJson(json['vo2Max'])
          : null,
      elevationGain: _safeParseDouble(json['elevationGain']),
      hasGps: json['hasGps'],
      shouldFetchDetails: json['shouldFetchDetails'],
      hasActiveZoneMinutes: json['hasActiveZoneMinutes'],
      time: timeStr,
      date: parsedDateTime,
    );
  }
}

class ActivityLevel {
  final int? minutes;
  final String? name;

  ActivityLevel({
    this.minutes,
    this.name,
  });

  factory ActivityLevel.fromJson(Map<String, dynamic> json) {
    return ActivityLevel(
      minutes: _safeParseInt(json['minutes']),
      name: json['name']?.toString(),
    );
  }
}

class ExerciseSource {
  final String type;
  final String name;
  final String id;
  final String url;
  final List<String> trackerFeatures;

  ExerciseSource({
    required this.type,
    required this.name,
    required this.id,
    required this.url,
    required this.trackerFeatures,
  });

  factory ExerciseSource.fromJson(Map<String, dynamic> json) {
    return ExerciseSource(
      type: json['type'] ?? 'Unknown',
      name: json['name'] ?? 'Unknown',
      id: json['id'] ?? 'Unknown',
      url: json['url'] ?? '',
      trackerFeatures: (json['trackerFeatures'] is List)
          ? List<String>.from(json['trackerFeatures'])
          : [],
    );
  }
}

class ManualValuesSpecified {
  final bool calories;
  final bool distance;
  final bool steps;

  ManualValuesSpecified({
    required this.calories,
    required this.distance,
    required this.steps,
  });

  factory ManualValuesSpecified.fromJson(Map<String, dynamic> json) {
    return ManualValuesSpecified(
      calories: json['calories'] ?? false,
      distance: json['distance'] ?? false,
      steps: json['steps'] ?? false,
    );
  }
}

class HeartRateZone {
  final String? name;
  final int? min;
  final int? max;
  final int? minutes;
  final double? caloriesOut;

  HeartRateZone({
    this.name,
    this.min,
    this.max,
    this.minutes,
    this.caloriesOut,
  });

  factory HeartRateZone.fromJson(Map<String, dynamic> json) {
    return HeartRateZone(
      name: json['name']?.toString(),
      min: _safeParseInt(json['min']),
      max: _safeParseInt(json['max']),
      minutes: _safeParseInt(json['minutes']),
      caloriesOut: _safeParseDouble(json['caloriesOut']),
    );
  }
}

class ActiveZoneMinutes {
  final int? totalMinutes;
  final List<HeartRateZoneMinutes>? minutesInHeartRateZones;

  ActiveZoneMinutes({
    this.totalMinutes,
    this.minutesInHeartRateZones,
  });

  factory ActiveZoneMinutes.fromJson(Map<String, dynamic> json) {
    return ActiveZoneMinutes(
      totalMinutes: _safeParseInt(json['totalMinutes']),
      minutesInHeartRateZones: (json['minutesInHeartRateZones'] is List)
          ? (json['minutesInHeartRateZones'] as List)
              .map((zone) => HeartRateZoneMinutes.fromJson(zone))
              .toList()
          : null,
    );
  }
}

class HeartRateZoneMinutes {
  final int? minutes;
  final String? zoneName;
  final int? order;
  final String? type;
  final int? minuteMultiplier;

  HeartRateZoneMinutes({
    this.minutes,
    this.zoneName,
    this.order,
    this.type,
    this.minuteMultiplier,
  });

  factory HeartRateZoneMinutes.fromJson(Map<String, dynamic> json) {
    return HeartRateZoneMinutes(
      minutes: _safeParseInt(json['minutes']),
      zoneName: json['zoneName']?.toString(),
      order: _safeParseInt(json['order']),
      type: json['type']?.toString(),
      minuteMultiplier: _safeParseInt(json['minuteMultiplier']),
    );
  }
}

class Vo2Max {
  final double? vo2Max;

  Vo2Max({
    this.vo2Max,
  });

  factory Vo2Max.fromJson(Map<String, dynamic> json) {
    return Vo2Max(
      vo2Max: _safeParseDouble(json['vo2Max']),
    );
  }
}
