
import 'package:fitness_app/services/setting_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../../models/dashboard_model.dart';
import '../../../services/dashboard_api.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();

}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime selectedDate = DateTime.now();
  DashboardData? dashboardData;
  bool isLoading = true;
  List<DashboardExercise> exercises = [];
  String userName = "";
  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }
  Future<void> _fetchUserInfo() async {
    try {
      final info = await SettingApi.getInformationUser();
      if (info.isNotEmpty) {
        setState(() {
          userName = info['name'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching user info: $e");
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildDashboardContent(),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/Ellipse 14.png'), // ✅ Đây là ImageProvider
                  ),

                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello " + (userName.isNotEmpty ? userName : '...')+"!",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),

                    ],
                  ),

                ],
              ),

              Row(
                children: [
                  Text(
                    DateFormat('EEEE, dd MMMM').format(selectedDate),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                    overflow: TextOverflow.ellipsis,

                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Colors.grey,

                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 301,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: (dashboardData?.timeCompletion ?? 0) / 160,
                              strokeWidth: 8,
                              backgroundColor: Colors.red.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "${dashboardData?.timeCompletion ?? 0}/160",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Text("Minutes", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/timer.png', width: 18, height: 18),
                          const SizedBox(width: 4),
                          const Text("Workout time", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _buildInfoCard(
                      icon: 'assets/weight.png',
                      label: "Calories burned",
                      value: dashboardData?.totalCaloriesBurned ?? '0',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: 'assets/clipboard-tick.png',
                      label: "Completion",
                      value: "${dashboardData?.exerciseCompletion ?? 0}/${dashboardData?.totalExercise ?? 0} Exercises",
                    ),
                  ],
                ),
              ),
            ],
          ),



          // Exercise Table
          const SizedBox(height: 24),
          const Text(
            "My exercises",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Expanded(flex: 2, child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text("Time", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Expanded(child: Text("Calories", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Expanded(child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              ],
            ),
          ),
          ...exercises.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(e.name)),
                  Expanded(child: Text("${e.time}", textAlign: TextAlign.center)),
                  Expanded(child: Text("${e.caloriesBurned}", textAlign: TextAlign.center)),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                          color: e.status == "completed" ? Colors.red : Colors.transparent,
                        ),
                        child: e.status == "completed"
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String icon, required String label, required String value}) {
    return Container(
      height: 145,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 20, height: 20),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

}
