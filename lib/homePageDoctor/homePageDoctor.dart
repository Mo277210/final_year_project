
import 'package:collogefinalpoject/homePageDoctor/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'doctor_profile.dart';

class HomepageDoctor extends StatelessWidget {
  const HomepageDoctor({super.key});

  @override
  Widget build(BuildContext context) {
   // showT
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(135.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
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
              indicatorWeight: 3,
              tabs: [//Icon( Icons.account_circle, ),
                Tab(icon: Icon( Icons.account_circle, color: Colors.black)),
                Tab(icon: Icon(Icons.settings,)),

              ],
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            children: [
              DoctorProfilePage(),
              SettingsPage(),
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
    home: HomepageDoctor()),
  );
}













