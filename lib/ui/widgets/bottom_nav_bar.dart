import 'package:flutter/material.dart';
import 'package:fitness_app/ui/screens/dashboard/dashboard.dart';
import 'package:fitness_app/ui/screens/my_exercise/my_exercise.dart';
import 'package:fitness_app/ui/screens/settings/settings.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(_createRoute('/'));
        break;
      case 1:
        Navigator.of(context).pushReplacement(_createRoute('/my-exercise'));
        break;
      case 2:
        Navigator.of(context).pushReplacement(_createRoute('/settings'));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.blue,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'My Exercise'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  PageRouteBuilder _createRoute(String routeName) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _getPage(routeName); // Hàm này trả về widget tương ứng với route
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  Widget _getPage(String routeName) {
    switch (routeName) {
      case '/':
        return const DashboardScreen(); // Đảm bảo rằng DashboardScreen được import chính xác
      case '/my-exercise':
        return const MyExerciseScreen(); // Đảm bảo rằng MyMealScreen được import chính xác
      case '/settings':
        return const SettingsScreen(); // Đảm bảo rằng SettingsScreen được import chính xác
      default:
        return const Scaffold(body: Center(child: Text('Unknown route')));
    }
  }
}
