import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/exercise.dart';

class ImpactApiService {
  static late String _baseUrl;
  static late String _username;
  static late String _password;
  static late String _patientUsername;

  static String? _accessToken;
  static String? _refreshToken;

  static bool _isInitialized = false;

  static Future<void> loadSettings() async {
    if (_isInitialized) return; // Prevents reinitialization

    try {
      final settingsData = await rootBundle.loadString(
        'lib/assets/settings.json',
      );
      final settings = jsonDecode(settingsData);

      _baseUrl = settings['baseUrl'];
      _username = settings['username'];
      _password = settings['password'];
      _patientUsername = settings['patientUsername'];

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load settings: $e');
    }
  }

  static Future<bool> authorize() async {
    final url = Uri.parse('${_baseUrl}gate/v1/token/');
    final response = await http.post(
      url,
      body: {'username': _username, 'password': _password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access'];
      _refreshToken = data['refresh'];
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> refreshTokens() async {
    if (_refreshToken == null) return false;

    final url = Uri.parse('${_baseUrl}gate/v1/refresh/');
    final response = await http.post(url, body: {'refresh': _refreshToken});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access'];
      _refreshToken = data['refresh'];
      return true;
    } else {
      return false;
    }
  }

  static Future<void> _ensureAuthorized() async {
    if (_accessToken == null) {
      final success = await authorize();
      if (!success) throw Exception('Initial login failed');
    } else if (JwtDecoder.isExpired(_accessToken!)) {
      final refreshed = await refreshTokens();
      if (!refreshed) {
        final loginAgain = await authorize();
        if (!loginAgain) throw Exception('Re-login after refresh failed');
      }
    }
  }

  static Future<List<dynamic>> fetchHeartRateDay({required String day}) async {
    await _ensureAuthorized();

    final url = Uri.parse(
      '$_baseUrl/data/v1/heart_rate/patients/$_patientUsername/day/$day/',
    );

    final headers = {HttpHeaders.authorizationHeader: 'Bearer $_accessToken'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Directly return the `data` field assuming it is always a list
      return data['data']['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch heart rate: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchCaloriesDay({required String day}) async {
    await _ensureAuthorized();

    final url = Uri.parse(
      '$_baseUrl/data/v1/calories/patients/$_patientUsername/day/$day/',
    );

    final headers = {HttpHeaders.authorizationHeader: 'Bearer $_accessToken'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Directly return the `data` field assuming it is always a list
      return data['data']['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch calories: ${response.statusCode}');
    }
  }

  /// Fetches exercise sessions for a given day.
  static Future<List<ExerciseSession>> fetchExerciseSessions(
      {required String day}) async {
    await _ensureAuthorized();

    final url = Uri.parse(
      '$_baseUrl/data/v1/exercise/patients/$_patientUsername/day/$day/',
    );

    final headers = {HttpHeaders.authorizationHeader: 'Bearer $_accessToken'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Handle different response structures
      try {
        // Check if the primary 'data' field exists and is not null
        if (data['data'] == null) {
          return [];
        }

        final responseData = data['data'];

        // Case 1: The nested 'data' field is the list of sessions
        if (responseData is Map && responseData['data'] is List) {
          final sessions = responseData['data'] as List;
          return sessions
              .map((session) => ExerciseSession.fromJson(session, date: day))
              .toList();
        }

        // Case 2: The 'data' field is already the list of sessions
        if (responseData is List) {
          return responseData
              .map((session) => ExerciseSession.fromJson(session, date: day))
              .toList();
        }

        // Case 3: The 'data' field is a complex object, try to parse it
        // This is a fallback if the structure is different than expected
        final exerciseData = ExerciseData.fromJson(responseData);
        return exerciseData.sessions;
      } catch (e) {
        debugPrint('Error parsing exercise data for $day: $e');
        debugPrint('Raw response data: $data');
        return []; // Return empty list on parsing error
      }
    } else if (response.statusCode == 400) {
      // 400 typically means no data for this day, which is a valid scenario.
      return [];
    } else {
      throw Exception(
          'Failed to fetch exercise sessions: ${response.statusCode}');
    }
  }

  /// Fetches all exercise sessions, starting from today and going backwards.
  static Future<List<ExerciseSession>> fetchAllExerciseSessions() async {
    await _ensureAuthorized();

    final allSessions = <ExerciseSession>[];
    var currentDate = DateTime.now();
    const maxEmptyDays = 7; // Stop after a week of no data
    var emptyDaysCount = 0;

    while (emptyDaysCount < maxEmptyDays) {
      final dayString =
          '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';

      try {
        final dailySessions = await fetchExerciseSessions(day: dayString);

        if (dailySessions.isNotEmpty) {
          allSessions.addAll(dailySessions);
          emptyDaysCount = 0; // Reset counter on finding data
        } else {
          emptyDaysCount++;
        }
      } catch (e) {
        debugPrint('Failed to fetch sessions for $dayString: $e');
        emptyDaysCount++; // Treat errors as an empty day
      }

      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return allSessions;
  }
}
