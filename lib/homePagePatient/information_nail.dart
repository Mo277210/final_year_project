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
    ' ALM',
    'Blue Finger',
    'Beaus Line',
    'Clubbing',
    'Koilonychia',
    ' Muehrckes Lines',
    ' Pitting',
    'Terrys Nail'
  ];
  final List<String> diseaseImages = [
    'assets/img_1.png',
    'assets/img_2.png',
    'assets/img_3.png',
    'assets/img_4.png',
    'assets/img_5.png',
    'assets/img_6.png',
    'assets/img_7.png',
    'assets/img_8.png',
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
            const SizedBox(height: 100),
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
                      fontSize: 28,
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
                        fontSize: 22,
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
