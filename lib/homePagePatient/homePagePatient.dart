import 'package:collogefinalpoject/homePagePatient/historyPage.dart';
import 'package:collogefinalpoject/homePagePatient/nagelimage.dart';
import 'package:collogefinalpoject/homePagePatient/setting_Patient_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'doctor_sreach_page.dart';
import 'information_nail.dart';

class Homepagepatient extends StatelessWidget {
  const Homepagepatient({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(135.0),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Nägel',
                  style: TextStyle(
                    color: Color(0xFF105DFB),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            bottom: const TabBar(
              indicatorColor: Colors.blue,
              indicatorWeight: 5,
              tabs: [
                Tab(icon: Icon(Icons.image_search, color: Colors.black)),
                Tab(
                    icon: ImageIcon(
                        AssetImage("assets/history.png"), color: Colors.black, size: 24)),
                Tab(
                    icon: ImageIcon(
                        AssetImage("assets/doctor2.png"), color: Colors.black, size: 29)),
                Tab(
                    icon: ImageIcon(
                        AssetImage("assets/evidence.png"), color: Colors.black, size: 29)),
                Tab(icon: Icon(Icons.settings,)),
              ],
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            children: [
              Nagelimage(),
              Historypage(),
              DoctorSearchPage(),
              InformationNail(),
              SettingPatientPage(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildpage(String text) => Center(
  child: Text(
    text,
    style: const TextStyle(fontSize: 20),
  ),
);

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Homepagepatient(),
  ));
}
