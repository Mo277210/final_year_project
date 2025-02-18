import 'package:collogefinalpoject/homePageDoctor/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'doctor_profile.dart';

class HomepageDoctor extends StatefulWidget {
  const HomepageDoctor({super.key});

  @override
  _HomepageDoctorState createState() => _HomepageDoctorState();
}

class _HomepageDoctorState extends State<HomepageDoctor> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<bool> _isPageLoaded = [false, false];

  final List<Widget> _pages = [
    const DoctorProfilePage(),
    const SettingsPage(),
  ];

  final List<int> _loadingTimes = [4, 6];

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
            bottom: TabBar(
              indicatorColor: Colors.blue,
              indicatorWeight: 3,
              onTap: _onTabTapped,
              tabs: const [
                Tab(icon: Icon(Icons.account_circle, color: Colors.black)),
                Tab(icon: Icon(Icons.settings)),
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
    home: HomepageDoctor(),
  ));
}
