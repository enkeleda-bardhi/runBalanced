import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

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
}
