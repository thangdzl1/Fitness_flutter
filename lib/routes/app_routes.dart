import 'package:fitness_app/ui/screens/authenticate/signin_screen.dart';
import 'package:flutter/material.dart';
import '../ui/screens/dashboard/dashboard.dart';
import '../ui/screens/my_exercise/my_exercise.dart';
import '../ui/screens/settings/account.dart'; // 👈 Thêm dòng này
import '../ui/screens/settings/settings.dart'; //
class AppRoutes {
  static const String dashboard = '/';
  static const String myMeal = '/my-meal';
  static const String settings = '/settings';
  static const String account = '/settings/account';
  static const String profile = '/settings/profile';              // ✅ mới
  static const String activity = '/settings/activity-level';
  static const String authenticate = '/authenticate/signin_screen';

  static final routes = {
    dashboard: (context) => const DashboardScreen(),
    myMeal: (context) => const MyMealScreen(),
    settings: (context) => const SettingsScreen(),
    account: (context) => const AccountScreen(),
    authenticate: (context) => SigninScreen(),
  };
}

