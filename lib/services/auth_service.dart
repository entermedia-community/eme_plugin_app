import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      'https://minsur.genailabs.tech/mediadb/services';

  static String? _token;
  static String? _userId;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('entermediakey');
    _userId = prefs.getString('user');
  }

  static bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  static String? get token => _token;
  static String? get userId => _userId;

  static Future<Map<String, String>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user');
    _token = prefs.getString('entermediakey');
    return {'user': _userId!, 'entermediakey': _token!};
  }

  static Future<void> saveCredentials(String userId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', userId);
    await prefs.setString('entermediakey', key);
    _token = key;
    _userId = userId;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('entermediakey');
    _token = null;
    _userId = null;
  }

  static Future<void> sendMagicLink(String email) async {
    final url = Uri.parse('$baseUrl/authentication/sendmagiclink.json');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, String> body = {'email': email};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final responseObj = data['response'];
        if (responseObj != null && responseObj['status'] == 'ok') {
          return;
        } else {
          final errorMsg =
              responseObj?['message'] ?? 'Failed to send magic link';
          throw Exception(errorMsg);
        }
      } else {
        throw Exception(
          'Failed to send magic link: Server returned status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to send magic link: $e');
    }
  }

  static Future<bool> _authenticate(Map<String, dynamic> requestBody) async {
    final url = Uri.parse('$baseUrl/authentication/getkey.json');
    final Map<String, String> headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final responseObj = data['response'];
        if (responseObj != null && responseObj['status'] == 'ok') {
          final userId = responseObj['user']?.toString() ?? '';
          final results = data['results'];
          final key = results?['entermediakey']?.toString() ?? '';

          if (userId.isNotEmpty && key.isNotEmpty) {
            await saveCredentials(userId, key);
            return true;
          } else {
            throw Exception('Authentication response missing user ID or key');
          }
        } else {
          final errorMsg = responseObj?['message'] ?? 'Authentication failed';
          throw Exception(errorMsg);
        }
      } else {
        throw Exception(
          'Authentication failed: Server returned status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }

  static Future<bool> loginWithOtp(String email, String otp) async {
    return _authenticate({'email': email, 'templogincode': otp});
  }
}
