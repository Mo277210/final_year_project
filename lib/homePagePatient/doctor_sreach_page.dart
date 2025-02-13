import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorSearchPage extends StatefulWidget {
  @override
  _DoctorSearchPageState createState() => _DoctorSearchPageState();
}

class _DoctorSearchPageState extends State<DoctorSearchPage> {
  String? selectedChip = 'All';

  @override
  Widget build(BuildContext context) {
    final specialties = ['All', 'Dermatology', 'Cardiology', 'Pediatrics'];

    return Scaffold(
      backgroundColor: Color(0xFFF1F4F8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find Your Doctor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff105dfb),
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFF105DFB),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            cursorColor: Color(0xFF105DFB),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search for doctors...',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Medical Specialties',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: specialties.map((specialty) {
                        final isSelected = selectedChip == specialty;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(specialty),
                            selected: isSelected,
                            selectedColor: Color(0xff105dfb),
                            backgroundColor: Colors.grey[300],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                selectedChip = specialty;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    DoctorCard(
                      name: "Dr. Mohamed Monaser",
                      specialty: "Dermatologist",
                      starRating: 4.5,
                      email: "dr.Monaser@clinic.com",
                      phone: "+2010909900",
                      availableHours: [
                        {"Main:Mon": "9:00-17:00"},
                        {"Branch:Tue": "9:00-17:00"},
                        {"Branch:Thu": "9:00-17:00"},
                        {"Branch:Fri": "9:00-15:00"},
                      ],
                      mainClinic: "6 Tahrir Street, directly above ",
                      branchClinic: "https://maps.app.goo.gl/bmm8j5hXVrZpEU5R6",
                    ),
                    DoctorCard(
                      name: "Dr. Mohamed Monaser",
                      specialty: "Dermatologist",
                      starRating: 4.5,
                      email: "dr.Monaser@clinic.com",
                      phone: "+2010909900",
                      availableHours: [
                        {"Main:Mon": "9:00-17:00"},
                        {"Branch:Tue": "9:00-17:00"},
                        {"Main:Thu": "9:00-17:00"},
                        {"Main:Fri": "9:00-15:00"},
                      ],
                      mainClinic: "6 Tahrir Street, directly above ",
                      branchClinic: "https://maps.app.goo.gl/bmm8j5hXVrZpEU5R6",
                    ),
                    DoctorCard(
                      name: "Dr. Mohamed Monaser",
                      specialty: "Dermatologist",
                      starRating: 4.5,
                      email: "dr.Monaser@clinic.com",
                      phone: "+2010909900",
                      availableHours: [
                        {"Main:Mon": "9:00-17:00"},
                        {"Branch:Tue": "9:00-17:00"},
                        {"Main:Thu": "9:00-17:00"},
                        {"Branch:Fri": "9:00-15:00"},
                      ],
                      mainClinic: "6 Tahrir Street, directly above ",
                      branchClinic: "https://maps.app.goo.gl/bmm8j5hXVrZpEU5R6",
                    ),
                    DoctorCard(
                      name: "Dr. Mohamed Monaser",
                      specialty: "Dermatologist",
                      starRating: 4.5,
                      email: "dr.Monaser@clinic.com",
                      phone: "+2010909900",
                      availableHours: [
                        {"Main:Mon": "9:00-17:00"},
                        {"Main:Tue": "9:00-17:00"},
                        {"Branch:Thu": "9:00-17:00"},
                        {"Main:Fri": "9:00-15:00"},
                      ],
                      mainClinic: "6 Tahrir Street, directly above ",
                      branchClinic: "https://maps.app.goo.gl/bmm8j5hXVrZpEU5R6",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double starRating;
  final String email;
  final String phone;
  final List<Map<String, String>> availableHours;
  final String mainClinic;
  final String branchClinic;

  const DoctorCard({
    required this.name,
    required this.specialty,
    required this.starRating,
    required this.email,
    required this.phone,
    required this.availableHours,
    required this.mainClinic,
    required this.branchClinic,
  });


  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  bool _isLink(String text) {
    return text.contains('http://') || text.contains('https://') || text.contains('www.');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/Doctorimage.jpg'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      specialty,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: starRating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: index < starRating
                                ? Colors.amber
                                : Colors.grey[400],
                          ),
                          onRatingUpdate: (rating) {
                            // Handle rating update
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "($starRating)",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, color: Color(0xFF105DFB)),
                SizedBox(width: 8),
                Text(email),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Color(0xFF105DFB)),
                SizedBox(width: 8),
                Text(phone),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Available Hours",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF105DFB),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: availableHours.map((dayTime) {
                  final day = dayTime.keys.first;
                  final time = dayTime.values.first;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "$day: $time",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Main Clinic",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF105DFB),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _isLink(mainClinic)
                ? InkWell(
              onTap: () => _launchUrl(mainClinic),
              child: Center(
                child: Text(
                  mainClinic,
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : Center(
              child: Text(
                mainClinic,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Branch Clinic",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF105DFB),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _isLink(branchClinic)
                ? InkWell(
              onTap: () => _launchUrl(branchClinic),
              child: Center(
                child: Text(
                  branchClinic,
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : Center(
              child: Text(
                branchClinic,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoctorSearchPage(),
    );
  }
}
