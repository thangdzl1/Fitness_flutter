import 'dart:convert';
import '../models/dashboard_model.dart';
import 'package:fitness_app/services/token_api.dart';

class DashboardApi {
  static final ApiClient _client = ApiClient();

  static Future<DashboardData?> getDiary(String date) async {
    final response = await _client.get('api/diaries/dashboard?date=$date');
    final data = jsonDecode(response.body);

    if (data['diaries'] != null) {
      return DashboardData.fromJson(data['diaries']);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> getExercisesByDate(String date) async {
    final response = await _client.get('api/exercises?date=$date');

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded;
    } else if (decoded is Map && decoded.containsKey('message')) {
      // Trường hợp có thông báo nhưng không có dữ liệu
      return [];
    } else {
      throw Exception('Unexpected response format: $decoded');
    }
  }

}
