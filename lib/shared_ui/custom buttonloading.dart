import 'package:flutter/material.dart';

class CustomButtonloading extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed; // Make this nullable
  final Color buttonColor;

  const CustomButtonloading({
    Key? key,
    required this.buttonText,
    this.onPressed, // Allow null for onPressed
    this.buttonColor = const Color(0xFF105DFB), // Default color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Use the nullable onPressed here
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}