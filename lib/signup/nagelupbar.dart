import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Nagelupbar extends StatelessWidget {
  const Nagelupbar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: 200,
      alignment: Alignment.center,
      color: Colors.white,
      child: const Text(
        'Nägel',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF105DFB),
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
