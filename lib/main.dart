import 'package:collogefinalpoject/login/loginScreenPatient.dart';
import 'package:collogefinalpoject/splashScreen/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreenPatient (),
    );
  }
}

