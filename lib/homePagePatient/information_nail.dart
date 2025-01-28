import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'exploer_disease.dart';

class InformationNail extends StatefulWidget {
  const InformationNail({super.key});

  @override
  State<InformationNail> createState() => _InformationNailState();
}

class _InformationNailState extends State<InformationNail> {
  final List<String> diseases = [
    'Onycholysis',
    'Nail Psoriasis',
    'Brittle Splitting Nails',
  ];

  final List<String> diseaseImages = [
    'assets/onycholysis.jpg',
    'assets/nail_psoriasis.jpg',
    'assets/brittle_splitting_nails.jpg',
  ];

  int currentDiseaseIndex = 0;

  void navigateDisease(int direction) {
    setState(() {
      if (direction == 1) {
        if (currentDiseaseIndex == diseases.length - 1) {
          currentDiseaseIndex = 0;
        } else {
          currentDiseaseIndex++;
        }
      } else if (direction == -1) {
        if (currentDiseaseIndex == 0) {
          currentDiseaseIndex = diseases.length - 1;
        } else {
          currentDiseaseIndex--;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.asset(
                diseaseImages[currentDiseaseIndex],
                height: 350,
                width: 350,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => navigateDisease(-1),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF105DFB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    diseases[currentDiseaseIndex],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => navigateDisease(1),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF105DFB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ElevatedButton(
                style: buttonPrimary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Explore ${diseases[currentDiseaseIndex]}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExploreDisease(
                        currentDiseaseIndex: currentDiseaseIndex,
                        diseases: diseases,
                        diseaseImages: diseaseImages,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  minimumSize: const Size(342, 60),
  backgroundColor: const Color(0xFF105DFB),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(26)),
  ),
);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InformationNail(),
    );
  }
}