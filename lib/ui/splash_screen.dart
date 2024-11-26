import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fify/ui/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'login_page.dart'; // Login ekranına yönlendirme için

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Splash ekranından sonraki sayfaya yönlendirme fonksiyonu
  void navigateToLogin() {
    // Fade geçişi ile LoginPage'e yönlendirme
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginPage(), // LoginScreen yerine LoginPage kullanıyoruz
        // Geçiş animasyonunu özelleştirmek için buildTransitions kullanıyoruz
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Fade transition animasyonu
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  // 2 saniyelik bir gecikme
  startTimer() {
    Timer(const Duration(seconds: 2), navigateToLogin);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.black,
                bgColor,
              ],
            ),
          ),
          child: Center(
            child: GradientText(
              'FIFYY',
              style: TextStyle(
                fontSize: 75.0,
                fontWeight: FontWeight.bold,
              ),
              colors: [
                Colors.blue,
                Colors.red,
                Colors.teal,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
