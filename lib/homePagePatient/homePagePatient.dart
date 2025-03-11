import 'package:collogefinalpoject/homePagePatient/historyPage.dart';
import 'package:collogefinalpoject/homePagePatient/nagelimage.dart';
import 'package:collogefinalpoject/homePagePatient/setting_Patient_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'doctor_sreach_page.dart';
import 'information_nail.dart';

class Homepagepatient extends StatefulWidget {
  const Homepagepatient({super.key});

  @override
  _HomepagepatientState createState() => _HomepagepatientState();
}

class _HomepagepatientState extends State<Homepagepatient> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<bool> _isPageLoaded = [false, false, false, false, false];

  final List<Widget> _pages = [
     Nagelimage(),
     Historypage(),
     DoctorSearchPage(),
     InformationNail(),
     SettingPatientPage(),
  ];

  final List<int> _loadingTimes = [3, 0, 0, 4, 0];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: _loadingTimes[0]), () {
      setState(() {
        _isLoading = false;
        _isPageLoaded[0] = true;
      });
    });
  }

  void _onTabTapped(int index) {
    if (_isPageLoaded[index]) {
      setState(() {
        _currentIndex = index;
      });
    } else {
      setState(() {
        _isLoading = true;
        _currentIndex = index;
      });
      Future.delayed(Duration(seconds: _loadingTimes[index]), () {
        setState(() {
          _isLoading = false;
          _isPageLoaded[index] = true;
        });
      });
    }
  }

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
            bottom: TabBar(
              indicatorColor: Colors.blue,
              indicatorWeight: 5,
              onTap: _onTabTapped,
              tabs: const [
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _pages[_currentIndex],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Homepagepatient(),
  ));
}
