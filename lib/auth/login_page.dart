import 'package:fify/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:fify/auth/database_helper.dart'; // Import DatabaseHelper
import '../ui/home_screen.dart'; // Import HomeScreen for navigation

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Toggle password visibility

  // Function to validate email format
  bool _isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  // Login process
  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Email and password cannot be empty.");
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorDialog("Please enter a valid email address.");
      return;
    }

    // Check user in the database
    final user = await DatabaseHelper.instance
        .getUserByEmailAndPassword(email, password);

    if (user != null) {
      // Login successful, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // User not found
      _showErrorDialog("Incorrect email or password.");
    }
  }

  // Simple dialog function to show error messages
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Password',
        hintStyle: const TextStyle(color: Colors.black),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0), // Common padding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                GradientText(
                  'FIFYY',
                  style: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'REM'),
                  colors: [
                    Colors.blue,
                    Colors.red,
                    Colors.teal,
                  ],
                ),
                const SizedBox(height: 75),

                // Email field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.black),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0), // Common padding
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildPasswordField(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Log In button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: _login,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 17),

                // Sign-up prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not a member?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        " Sign Up Now!",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
