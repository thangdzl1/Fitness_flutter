import 'package:flutter/material.dart';
import '../../../services/setting_api.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final data = await SettingApi.getInformationUser();
      nameCtrl.text = data['name'] ?? '';
      emailCtrl.text = data['email'] ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch user info")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() != true) return;

    try {
      final response = await SettingApi.updateUser(
        name: nameCtrl.text,
        email: emailCtrl.text,
        password: passwordCtrl.text,
        newPassword: newPasswordCtrl.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account"), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Name"),
              const SizedBox(height: 6),
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Text("Email"),
              const SizedBox(height: 6),
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const Text("Change Password"),
              const SizedBox(height: 6),
              TextFormField(
                controller: passwordCtrl,
                decoration: const InputDecoration(
                  labelText: "Current Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: newPasswordCtrl,
                decoration: const InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text("Save changes"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
