import 'package:flutter/material.dart';
import 'ui/splash_screen.dart'; // SplashScreen'i çağırıyoruz

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIFY App',
      theme: ThemeData(
        fontFamily:
            'Arial', // Varsayılan font olarak SubstanceMedium kullanıyoruz
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // SplashScreen ilk açılan ekran
    );
  }
}
