import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Historypage extends StatelessWidget {
  Historypage({Key? key}) : super(key: key);

  final List<String> Onycholysis = ["0.1", "0.1", "0.1"];
  final List<String> Nail_Psoriasis = ["0.3", "0.6", "0.5"];
  final List<String> Brittle_Splitting_Nails = ["0.4", "0.4", "0.3"];

  final List<String> diseases = [
    'Clubbing',
    'Beaus Line',
    'Blue Finger',
  ];

  final List<String> diseaseImages = [
    'assets/onycholysis.jpg',
    'assets/nail_psoriasis.jpg',
    'assets/brittle_splitting_nails.jpg',
  ];

  String getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: List.generate(diseases.length, (index) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    diseaseImages[index],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    diseases[index],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    getCurrentDate(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Clubbing: \n ${Onycholysis[index]}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Beaus Line: \n ${Nail_Psoriasis[index]}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Blue Finger: \n ${Brittle_Splitting_Nails[index]}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Historypage(),
  ));
}
