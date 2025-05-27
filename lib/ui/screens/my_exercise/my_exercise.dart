import 'package:flutter/material.dart';

import '../../../models/myexercise_model.dart';
import '../../../services/myexercise_api.dart';
import '../../widgets/bottom_nav_bar.dart';

class MyExerciseScreen extends StatefulWidget {
  const MyExerciseScreen({super.key});

  @override
  State<MyExerciseScreen> createState() => _MyExerciseScreenState();
}

class _MyExerciseScreenState extends State<MyExerciseScreen> {
  DateTime _selectedDate = DateTime.now();
  List<ExerciseItem> _exercises = [];

  @override
  void initState() {
    super.initState();
    _initDiaryAndLoad();
  }

  Future<void> _initDiaryAndLoad() async {
    final dateStr = _formatDate(_selectedDate);
    try {
      await MyExerciseApi.createDiary(dateStr);
      await _fetchExercisesByDate(dateStr);
    } catch (e) {
      print('Error initializing diary: $e');
    }
  }

  Future<void> _fetchExercisesByDate(String dateStr) async {
    try {
      final data = await MyExerciseApi.getExercisesByDate(dateStr);
      final exercises =
          (data as List).map((e) => ExerciseItem.fromJson(e)).toList();
      setState(() {
        _exercises = exercises;
      });
    } catch (e) {
      print('Error fetching exercises: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _navigateToAddExercise() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChooseExerciseScreen(selectedDate: _selectedDate),
      ),
    );
    if (result == true) {
      await _initDiaryAndLoad();
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      await _initDiaryAndLoad();
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isToday =
        _selectedDate.year == today.year &&
        _selectedDate.month == today.month &&
        _selectedDate.day == today.day;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Exercise"),
        actions: [
          IconButton(
            onPressed: _navigateToAddExercise,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () async {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(
                        const Duration(days: 1),
                      );
                    });
                    await _initDiaryAndLoad();
                  },
                ),
                Text(
                  isToday
                      ? 'Today'
                      : '${_selectedDate.day} ${_getMonthName(_selectedDate.month)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                    setState(() {
                      _selectedDate = _selectedDate.add(
                        const Duration(days: 1),
                      );
                    });
                    await _initDiaryAndLoad();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _exercises.isEmpty
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/kettlebell.png', height: 100),
                        const SizedBox(height: 16),
                        const Text(
                          "There isn't any exercise in your list. Let's add\nexercises to be good fit now!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _navigateToAddExercise,
                          icon: const Icon(Icons.add),
                          label: const Text('Add new exercise'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    )
                    : ListView.builder(
                      itemCount: _exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = _exercises[index];
                        bool isCompleted = exercise.status == "completed";

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      exercise.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1A1A2E),
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Bấm vào phần bên trái sẽ mở màn sửa
                                        GestureDetector(
                                          onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => EditExerciseScreen(
                                                      exerciseItem: exercise,
                                                      selectedDate:
                                                          _selectedDate,
                                                    ),
                                              ),
                                            );

                                            if (result == true) {
                                              await _initDiaryAndLoad();
                                            }
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Time: ${exercise.time} minutes',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Calorie burned: ${exercise.caloriesBurned} kcal',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Phần checkbox - không bị bọc GestureDetector
                                        Checkbox(
                                          value: exercise.status == "completed",
                                          onChanged: (value) async {
                                            try {
                                              await MyExerciseApi.updateExercise(
                                                exerciseID: exercise.exerciseID,
                                                date: _formatDate(
                                                  _selectedDate,
                                                ),
                                                time: exercise.time,
                                                weight: exercise.weight.toInt(),
                                                status:
                                                    value!
                                                        ? "completed"
                                                        : "uncompleted",
                                              );
                                              await _initDiaryAndLoad();
                                            } catch (e) {
                                              print('Update status failed: $e');
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Failed to update status',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

class ChooseExerciseScreen extends StatefulWidget {
  final DateTime selectedDate;

  const ChooseExerciseScreen({super.key, required this.selectedDate});

  @override
  State<ChooseExerciseScreen> createState() => _ChooseExerciseScreenState();
}

class _ChooseExerciseScreenState extends State<ChooseExerciseScreen> {
  List<ExerciseBasic> _exerciseList = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final data = await MyExerciseApi.getAllExercise();
      final list =
          (data as List).map((e) => ExerciseBasic.fromJson(e)).toList();
      setState(() {
        _exerciseList = list;
      });
    } catch (e) {
      print("Error fetching exercises: $e");
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _handleAddExercise(BuildContext context, ExerciseBasic item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ExerciseDetailsScreen(
              exerciseID: item.exerciseID,
              exerciseName: item.name,
              met: item.met,
              selectedDate: widget.selectedDate,
            ),
      ),
    );

    if (result != null && result is List<ExerciseItem>) {
      Navigator.pop(
        context,
        true,
      ); // Trả về true để MyExerciseScreen reload lại
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Exercise')),
      body: ListView.builder(
        itemCount: _exerciseList.length,
        itemBuilder: (context, index) {
          final item = _exerciseList[index];
          return ListTile(
            title: Text(item.name),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _handleAddExercise(context, item),
            ),
          );
        },
      ),
    );
  }
}

class ExerciseDetailsScreen extends StatefulWidget {
  final int exerciseID;
  final String exerciseName;
  final DateTime selectedDate;
  final double met;

  const ExerciseDetailsScreen({
    super.key,
    required this.exerciseID,
    required this.exerciseName,
    required this.selectedDate,
    required this.met,
  });

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  int _time = 10;
  int _weight = 65;
  int _caloriesBurned = 100;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _saveExercise() async {
    try {
      final dateStr = _formatDate(widget.selectedDate);

      await MyExerciseApi.addExercise(
        exerciseID: widget.exerciseID,
        status: 'uncompleted',
        weight: _weight,
        time: _time,
        date: dateStr,
      );

      // Lấy lại danh sách bài tập sau khi thêm thành công
      final updatedData = await MyExerciseApi.getExercisesByDate(dateStr);

      final updatedExercises =
          (updatedData as List).map((e) => ExerciseItem.fromJson(e)).toList();

      // Quay về màn hình trước và trả kết quả mới
      Navigator.pop(context, updatedExercises);
    } catch (e) {
      print("Error adding exercise: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to add exercise')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How many calories do you want to burn?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Exercise', style: TextStyle(fontSize: 16)),
                Text(widget.exerciseName, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Time', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 120,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(
                      suffixText: 'minutes',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _time.toString()),
                    onChanged: (value) {
                      setState(() {
                        _time = int.tryParse(value) ?? 0;
                        _caloriesBurned =
                            (_time * _weight * widget.met).round();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your weight', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 120,
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(
                      suffixText: 'kgs',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _weight.toString()),
                    onChanged: (value) {
                      setState(() {
                        _weight = int.tryParse(value) ?? 0;
                        _caloriesBurned =
                            (_time * _weight * widget.met).round();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Calorie burned', style: TextStyle(fontSize: 16)),
                Text(
                  '$_caloriesBurned kcal',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save changes', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class EditExerciseScreen extends StatefulWidget {
  final ExerciseItem exerciseItem;
  final DateTime selectedDate;

  const EditExerciseScreen({
    super.key,
    required this.exerciseItem,
    required this.selectedDate,
  });

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  late int _time;
  late int _weight;
  late double _met;
  late int _calories;

  @override
  void initState() {
    super.initState();
    _time = widget.exerciseItem.time;
    _weight = widget.exerciseItem.weight.toInt();
    _met =
        double.tryParse(widget.exerciseItem.caloriesBurned)! /
        (_time * _weight);
    _calories = (_time * _weight * _met).round();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _deleteExercise() async {
    final confirm = await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Are you sure want to delete this exercise?',
              style: TextStyle(color: Colors.brown),
            ),
            content: const Text('You won’t be able to undo it.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.brown),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.brown),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await MyExerciseApi.deleteExercise(
          exerciseID: widget.exerciseItem.exerciseID,
          date: _formatDate(widget.selectedDate),
        );
        Navigator.pop(context, true); // báo về MyExerciseScreen reload
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Delete failed')));
      }
    }
  }

  Future<void> _saveChanges() async {
    try {
      await MyExerciseApi.updateExercise(
        exerciseID: widget.exerciseItem.exerciseID,
        date: _formatDate(widget.selectedDate),
        weight: _weight,
        time: _time,
        status: "uncompleted", // giữ nguyên status là uncompleted (tuỳ logic)
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Update failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise details'),
        leading: BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _deleteExercise,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How many calories do you want to burn?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Exercise', style: TextStyle(fontSize: 16)),
                Text(
                  widget.exerciseItem.name,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Time', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      suffixText: 'minutes',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _time.toString()),
                    onChanged: (val) {
                      setState(() {
                        _time = int.tryParse(val) ?? 0;
                        _calories = (_time * _weight * _met).round();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your weight', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      suffixText: 'kgs',
                      border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(text: _weight.toString()),
                    onChanged: (val) {
                      setState(() {
                        _weight = int.tryParse(val) ?? 0;
                        _calories = (_time * _weight * _met).round();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Calorie burned', style: TextStyle(fontSize: 16)),
                Text('$_calories kcal', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save changes', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
