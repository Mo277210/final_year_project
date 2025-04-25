import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/api/patient_home/DoctorRating.dart';
import 'package:collogefinalpoject/api/patient_home/patient_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorSearchPage extends StatefulWidget {
  @override
  _DoctorSearchPageState createState() => _DoctorSearchPageState();
}

class _DoctorSearchPageState extends State<DoctorSearchPage> {
  String? selectedChip = 'All';
  List<Doctor> doctors = [];
  List<Doctor> filteredDoctors = [];
  bool isLoading = false;
  bool isDisposed = false;
  final TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  String? patientAddress;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
    _fetchPatientAddress();
  }

  @override
  void dispose() {
    isDisposed = true;
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchPatientAddress() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    try {
      // Fetch patient info using PatientInfoApiService
      final patientInfoResponse = await PatientInfoApiService().getPatientInfo(tokenProvider.token);
      if (!isDisposed) {
        setState(() {
          patientAddress = patientInfoResponse?.data.address != null && patientInfoResponse!.data.address.isNotEmpty
              ? patientInfoResponse.data.address
              : 'Unknown Address'; // Fallback address if API returns null or an empty address
          searchController.text = patientAddress ?? ''; // Use null-coalescing operator
        });
        // Trigger filtering based on the new address
        _filterDoctors();
      }
    } catch (e) {
      if (!isDisposed) {
        setState(() {
          patientAddress = 'Unknown Address'; // Fallback address in case of error
          searchController.text = ''; // Clear the search field if there's an error
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch patient address: $e')),
        );
      }
    }
  }

  Future<void> _fetchDoctors() async {
    if (isDisposed) return;
    setState(() {
      isLoading = true;
      filteredDoctors = [];
    });
    try {
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      final response = await http.get(
        Uri.parse('https://nagel-production.up.railway.app/api/patient/showDoctors'),
        headers: {
          'Authorization': 'Bearer ${tokenProvider.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> doctorsJson = data['data'];
        final fetchedDoctors = doctorsJson.map((json) => Doctor.fromJson(json)).toList();
        if (!isDisposed) {
          setState(() {
            doctors = fetchedDoctors;
            filteredDoctors = fetchedDoctors;
            isLoading = false;
          });
        }
      } else {
        if (!isDisposed) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load doctors: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (!isDisposed) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load doctors: $e')),
        );
      }
    }
  }

  void _filterDoctors() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty && selectedChip == 'All') {
      setState(() {
        filteredDoctors = doctors;
      });
      return;
    }
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        // Filter by selected specialty
        final matchesSpecialty = selectedChip == 'All' ||
            doctor.specialization.toLowerCase().contains(selectedChip!.toLowerCase());
        // Search in name, specialty, or clinic addresses
        final matchesSearch = query.isEmpty ||
            doctor.name.toLowerCase().contains(query) ||
            doctor.specialization.toLowerCase().contains(query) ||
            doctor.clinics.any((clinic) => clinic.address.toLowerCase().contains(query));
        return matchesSpecialty && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final specialties = ['All',
      "Dermatology", // الجلدية
    "Oncology", // الأورام
    "Cardiology", // أمراض القلب
    "Vascular Medicine", // الأوعية الدموية
    "Pulmonology", // الرئة
    "Internal Medicine", // الطب الباطني
    "Nutrition", // التغذية
    "Endocrinology", // الغدد الصماء
    "Hematology", // أمراض الدم
    "Hepatology", // أمراض الكبد
    "Nephrology", // أمراض الكلى
    "Rheumatology", // الروماتيزم
    "Immunology", // أمراض المناعة الذاتية
    "Gastroenterology", //الجهاز الهضمي
    ];
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
                            controller: searchController,
                            focusNode: searchFocusNode,
                            cursorColor: Color(0xFF105DFB),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search by name, specialty or address...',
                            ),
                            onChanged: (_) => _filterDoctors(),
                          ),
                        ),
                        if (searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              _filterDoctors();
                              searchFocusNode.requestFocus();
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Medical Specialties',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
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
                                _filterDoctors();
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
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredDoctors.isEmpty
                  ? Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'No doctors found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      if (searchController.text.isNotEmpty || selectedChip != 'All')
                        TextButton(
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              selectedChip = 'All';
                            });
                            _filterDoctors();
                          },
                          child: Text('Clear all filters'),
                        ),
                    ],
                  ),
                ),
              )
                  : RefreshIndicator(
                onRefresh: _fetchDoctors,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
                      return DoctorCard(
                        doctor: doctor,
                        onRatingUpdated: (newRating) {
                          setState(() {
                            doctor.rating = newRating;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Doctor {
  final int id;
  final String name;
  final String email;
  final String phone;
  double? rating;
  final String specialization;
  num totalRatings;
  final String? photo;
  final List<Clinic> clinics;
  final List<String> availableHours;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.rating,
    required this.specialization,
    required this.totalRatings,
    this.photo,
    required this.clinics,
    required this.availableHours,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Doctor',
      email: json['email'] ?? 'No email provided',
      phone: json['phone'] ?? 'No phone provided',
      rating: json['rating']?.toDouble() ?? 0.0,
      specialization: json['specialization'] ?? 'General Practitioner',
      totalRatings: json['total_ratings']?.toDouble() ?? 0.0,
      photo: json['photo'],
      clinics: (json['clinics'] as List? ?? []).map((clinic) => Clinic.fromJson(clinic)).toList(),
      availableHours: List<String>.from(json['available_hours'] ?? []),
    );
  }
}

class Clinic {
  final String name;
  final String address;
  final String phone;

  Clinic({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      name: json['name'] ?? 'Unknown Clinic',
      address: json['address'] ?? 'Unknown Address',
      phone: json['phone'] ?? 'No phone provided',
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final Function(double) onRatingUpdated;

  const DoctorCard({
    required this.doctor,
    required this.onRatingUpdated,
  });

  Future<void> _launchUrl(String url) async {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double rating = doctor.rating != null ? (doctor.rating! > 5 ? 5 : doctor.rating!) : 0;
    final totalRatings = doctor.totalRatings > 5 ? 5 : doctor.totalRatings;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: doctor.photo != null &&
                        Uri.tryParse(doctor.photo!)?.hasScheme == true &&
                        Uri.tryParse(doctor.photo!)?.hasAuthority == true
                        ? NetworkImage(doctor.photo!)
                        : const AssetImage('assets/doctor.png') as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. ${doctor.name}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          doctor.specialization,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating:  totalRatings?.toDouble() ?? 0.0,
                              minRating: 1,
                              maxRating: 5,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              unratedColor: Colors.grey[400],
                              onRatingUpdate: (newRating) async {
                                try {
                                  final result = await DoctorRatingApiService.rateDoctor(
                                    doctorId: doctor.id,
                                    context: context,
                                    rating: newRating,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Rating submitted! New average: ${result.newRating.toStringAsFixed(1)}'),
                                    ),
                                  );
                                  onRatingUpdated(result.newRating);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to submit rating: $e'),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "($totalRatings reviews)",
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email, color: Color(0xFF105DFB)),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      doctor.email,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, color: Color(0xFF105DFB)),
                  SizedBox(width: 8),
                  Text(doctor.phone),
                ],
              ),
              if ((doctor.availableHours ?? []).isNotEmpty) ...[
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
                    children: (doctor.availableHours ?? []).map((hour) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          hour,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              if ((doctor.clinics ?? []).isNotEmpty) ...[
                ...(doctor.clinics ?? []).map((clinic) => Column(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        "${clinic.name} Clinic",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF105DFB),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          final isValidUrl = Uri.tryParse(clinic.address)?.hasScheme == true &&
                              (clinic.address.startsWith('http://') || clinic.address.startsWith('https://'));
                          if (isValidUrl) {
                            _launchUrl(clinic.address);
                          } else {
                            // Do nothing or just show an alert when it's not a valid URL
                          }
                        },
                        child: Text(
                          clinic.address,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Uri.tryParse(clinic.address)?.hasScheme == true &&
                                (clinic.address.startsWith('http://') || clinic.address.startsWith('https://'))
                                ? Colors.blue
                                : Colors.black,
                            decoration: Uri.tryParse(clinic.address)?.hasScheme == true &&
                                (clinic.address.startsWith('http://') || clinic.address.startsWith('https://'))
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        clinic.phone,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

