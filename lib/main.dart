import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:maverick_controller/bt_service/SelectBondedDevicePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: AnimatedSplashScreen(
        splash: "lib/maverick.png",
        splashTransition: SplashTransition.scaleTransition,
        nextScreen: const SelectBondedDevicePage(checkAvailability: false),
        backgroundColor: const Color(0xFF3B4259),
        curve: Curves.decelerate,
      ),
    );
  }
}
