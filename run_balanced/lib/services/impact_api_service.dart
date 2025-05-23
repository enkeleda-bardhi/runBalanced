import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class ImpactApiService {
  static const String _baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static const String _tokenEndpoint = 'gate/v1/token/';
  static const String _refreshEndpoint = 'gate/v1/refresh/';
  static const String _heartRateEndpoint = 'data/v1/heart_rate/patients/';

  static const String _username = 'qWgEn2F4fj';
  static const String _password = '12345678!';

  static String? _accessToken;
  static String? _refreshToken;

  static Future<bool> authorize() async {
    final url = Uri.parse(_baseUrl + _tokenEndpoint);
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

    final url = Uri.parse(_baseUrl + _refreshEndpoint);
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

  static Future<List<dynamic>> fetchHeartRateDay({
    required String patientUsername,
    required String day,
  }) async {
    await _ensureAuthorized();

    final url = Uri.parse(
      '$_baseUrl$_heartRateEndpoint$patientUsername/day/$day/',
    );

    final headers = {HttpHeaders.authorizationHeader: 'Bearer $_accessToken'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to fetch heart rate: ${response.statusCode}');
    }
  }
}
