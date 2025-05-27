import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateApi {
  static final String? baseUrl = dotenv.env['API_URL'];

  static Future<String?> signin(String email, String password) async {
    if (baseUrl == null) {
      print('API_URL not found in .env');
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}api/users/login'),
        // adjust this to your actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Message: ${data['message']}');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken',data['token']);
        return data['token'];
      } else {
        print('Failed to signin: ${response.statusCode + jsonDecode(response.body)}');
        return null;
      }
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  static Future<String?> signup({
    required String email,
    required String password,
    required String name,}) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}api/users/register'), // Adjust this if needed
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Message: ${data['message']}');
        return data['message'];
      } else {
        print('Failed to signup: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }
}
