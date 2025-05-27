import 'package:fitness_app/services/token_api.dart';
import 'dart:convert';

class MyExerciseApi {
  static final ApiClient _client = ApiClient();

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

  static Future<Map<String, dynamic>> createDiary(String date) async {
    final response = await _client.post(
      'api/diaries',
      body: {'date': date},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> addExercise({
    required int exerciseID,
    required String status,
    required int weight,
    required int time,
    required String date,

  }) async {
    final response = await _client.post(
      'api/exercises/add',
      body: {
        'date': date,
        'exerciseID': exerciseID,
        'status': status,
        'weight': weight,
        'time': time,
      },
    );
    return jsonDecode(response.body);
  }
  static Future<Map<String, dynamic>> updateExercise({
    required int exerciseID,
    required String status,
    required String date,
    required int weight,
    required int time,
  }) async {
    final response = await _client.put(
      'api/exercises/$exerciseID',
      body: {'date': date, 'status': status, 'weight': weight, 'time': time},
    );
    return jsonDecode(response.body);
  }

  static Future<void> deleteExercise({
    required int exerciseID,
    required String date,
  }) async {
    await _client.delete(
      'api/exercises/$exerciseID',
      body: {'date': date},
    );
  }
}
