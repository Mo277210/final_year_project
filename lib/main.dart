import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/login/loginScreenDoctor.dart';
import 'package:collogefinalpoject/login/loginScreenPatient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TokenProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreenPatient(),
    );
  }
}