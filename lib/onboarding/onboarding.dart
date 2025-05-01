import 'package:collogefinalpoject/login/loginScreenPatient.dart';
import 'package:collogefinalpoject/shared_ui/customButton.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SafeArea(
                child: Image.asset(
                    "assets/onboarding_blue.png"),
              ),
              const SizedBox(height: 50),
              Text(
                'Welcome to Nägel',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF105DFB),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Your nails can tell a story about your health.\n"
                "Nägel utilizes advanced AI to help you understand these vital signs.\n"
                "By simply using your device's camera,\n"
                "you can gain insights into potential nail conditions and receive guidance\n"
                "on the appropriate medical specialty to consult,\n"
                "empowering you to take proactive steps towards your well-being.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: CustomButton(
                  buttonText: 'Get Started',
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreenPatient()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
