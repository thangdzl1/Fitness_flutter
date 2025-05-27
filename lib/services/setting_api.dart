import 'dart:convert';
import 'package:fitness_app/services/token_api.dart';

class SettingApi {
  static final ApiClient _client = ApiClient();

  static Future<Map<String, dynamic>> updateUser({
    String? name,
    String? email,
    String? password,
    String? newPassword,
  }) async {
    final Map<String, dynamic> body = {};

    if (name != null && name.isNotEmpty) body['name'] = name;
    if (email != null && email.isNotEmpty) body['email'] = email;
    if (password != null && password.isNotEmpty) body['password'] = password;
    if (newPassword != null && newPassword.isNotEmpty) body['newPassword'] = newPassword;

    final response = await _client.put('api/users/setting', body: body);
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getInformationUser() async {
    final response = await _client.get('api/users/setting');
    return jsonDecode(response.body);
  }
}
