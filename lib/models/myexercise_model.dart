class ExerciseItem {
  final int exerciseID;
  final String name;
  final int time;
  final String status;
  final double weight;
  final String caloriesBurned;

  ExerciseItem({
    required this.exerciseID,
    required this.name,
    required this.time,
    required this.status,
    required this.weight,
    required this.caloriesBurned,
  });

  factory ExerciseItem.fromJson(Map<String, dynamic> json) {
    return ExerciseItem(
      exerciseID: json['exercise_id'],
      name: json['exercise']['name'],
      time: json['time'],
      status: json['status'],
      weight: json['weight'].toDouble(),
      caloriesBurned: json['calories_burned'].toString(),
    );
  }
}

class ExerciseBasic {
  final int exerciseID;
  final String name;
  final double met;
  ExerciseBasic({required this.exerciseID, required this.name,required this.met});

  factory ExerciseBasic.fromJson(Map<String, dynamic> json) {
    return ExerciseBasic(
      exerciseID: json['exercise_id'],
      name: json['name'],
      met: (json['met'] as num).toDouble()
    );
  }
}
