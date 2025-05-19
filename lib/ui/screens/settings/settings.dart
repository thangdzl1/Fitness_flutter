import 'package:flutter/material.dart';
import 'package:fitness_app/routes/app_routes.dart';
import '../../widgets/bottom_nav_bar.dart'; // Thêm dòng này nếu chưa import


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), centerTitle: true),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Account"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.account);
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Log out"),
            onTap: () {},
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2), // 👈 Thêm dòng này
    );
  }
}
