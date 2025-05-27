class DashboardExercise {
  final String name;
  final int time;
  final int caloriesBurned;
  final String status;

  DashboardExercise({
    required this.name,
    required this.time,
    required this.caloriesBurned,
    required this.status,
  });

  factory DashboardExercise.fromJson(Map<String, dynamic> json) {
    return DashboardExercise(
      name: json['exercise']?['name'] ?? '',
      time: json['time'] ?? 0,
      caloriesBurned: int.tryParse(json['calories_burned'].toString()) ?? 0,
      status: json['status'] ?? 'uncompleted',
    );
  }
}

class DashboardData {
  final int diaryId;
  final int userId;
  final String date;
  final int totalTime;
  final int exerciseCompletion;
  final String totalCaloriesBurned;
  final int timeCompletion;
  final int totalExercise;

  DashboardData({
    required this.diaryId,
    required this.userId,
    required this.date,
    required this.totalTime,
    required this.exerciseCompletion,
    required this.totalCaloriesBurned,
    required this.timeCompletion,
    required this.totalExercise,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      diaryId: json['diary_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      date: json['date'] ?? '',
      totalTime: json['total_time'] ?? 0,
      exerciseCompletion: json['exercise_completion'] ?? 0,
      totalCaloriesBurned: json['total_calories_burned'] ?? '0',
      timeCompletion: json['time_completion'] ?? 0,
      totalExercise: json['total_exercise'] ?? 0,
    );
  }

  static DashboardData empty() => DashboardData(
    diaryId: 0,
    userId: 0,
    date: "",
    totalTime: 0,
    exerciseCompletion: 0,
    totalCaloriesBurned: "0",
    timeCompletion: 0,
    totalExercise: 0,
  );
}
