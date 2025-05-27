import 'dart:convert';

import 'package:fitness_app/services/authenticate_api.dart';
import 'package:fitness_app/ui/screens/authenticate/forgot_password_screen.dart';
import 'package:fitness_app/ui/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreen();
}

class _SigninScreen extends State<SigninScreen> {

  bool _isChecked = false;
  bool _isLogin = false; // Boolean to toggle between login and create account
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin; // Toggle between login and create account
    });
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isLogin ? 'Welcome Back' : 'Create Account',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _isLogin
                        ? 'Create new account?'
                        : 'Already have an account?',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      _isLogin ? 'Sign up' : 'Login',
                      style: TextStyle(
                        color: Colors.blue, // Style the text
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // space before input fields
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (!_isLogin) // Show only in Create Account mode
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I agree to DopeSass Terms of service and Privacy policy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),

              // Show forgot password text only when in login mode
              if (_isLogin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  // Align to the right
                  children: [
                    TextButton(
                      onPressed: _forgotPassword, // Forgot password logic
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.black, // Style the text
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              // Adds space between the checkbox text and the button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLogin ? _loginForm : _signupForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE16449),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _isLogin ? 'Login' : 'Create an Account',
                      style: TextStyle(
                        fontWeight: FontWeight.w600, // semi-bold text
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Set the color of the divider
                      thickness: 1.5, // Set the thickness of the line
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or', // The "or" text in the middle
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey, // Set the color of the divider
                      thickness: 1.5, // Set the thickness of the line
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Adds space between the "or" line and the next button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle Google sign-in action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // Background color of the button
                      // onPrimary: Colors.black, // Text and icon color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey), // Border color
                      ),
                    ),
                    icon: Image.asset(
                      'assets/google_icons.webp',
                      // Path to your Google icon image
                      width: 24,
                      height: 24,
                    ),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginForm() async {
    String email = emailController.text;
    String password = passwordController.text;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return; // ⛔ Stop the action here
    }
    try {
      String? token = await AuthenticateApi.signin(email, password);

      if (token != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login successful!"),
              backgroundColor: Colors.green),
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwtToken', token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardScreen()),
        );
      } else {
        // Show error using a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _signupForm() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please accept our policy to continue'),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email and password cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String? response = await AuthenticateApi.signup(
        email: email,
        password: password,
      );
      if (response != null) {
        print('Signup success: $response');
        _loginForm();
      } else {
        final error = 'Signup failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
