import 'dart:convert';
import 'dart:io';
import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/api/doctor_home/AvailableHour.dart';
import 'package:collogefinalpoject/api/doctor_home/addhourse.dart';
import 'package:collogefinalpoject/api/doctor_home/sendimage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../api/doctor_home_api.dart'; // Import DoctorAPIService
import '../model/doctor_home_model.dart';
import '../api/doctor_home/show_clinc.dart';
import '../model/doctor_home/show_clinc.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({Key? key}) : super(key: key);

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  File? _image;
  List<String> _availableHours = []; // Initialize as an empty list
  String _mainClinic = "No main clinic available";
  String _mainClinicPhone = "N/A"; // Add phone for Main Clinic
  String _branchClinic = "No branch clinic available";
  String _branchClinicPhone = "N/A"; // Add phone for Branch Clinic
  DoctorInfoModel? _doctorInfo;
  bool _isLoading = true;
  String _errorMessage = '';
  List<showClinic> _clinics = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctorInfo();
    _fetchClinics();
    _fetchAvailableHours(); // Fetch available hours from the API
  }

  Future<void> _fetchDoctorInfo() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final token = tokenProvider.token;
    final apiService = DoctorAPIService();
    try {
      final doctorInfo = await apiService.getDoctorInfo(token);
      setState(() {
        _doctorInfo = doctorInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch doctor info: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchClinics() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final token = tokenProvider.token; // Retrieve the token
    final clinicApiService = ClinicApiService();
    try {
      final clinics = await clinicApiService.getClinics(token); // Pass the token
      setState(() {
        if (clinics.isEmpty) {
          // Use fallback values when no clinics are found
          _mainClinic = "No main clinic available";
          _mainClinicPhone = "N/A";
          _branchClinic = "No branch clinic available";
          _branchClinicPhone = "N/A";
        } else {
          _clinics = clinics;
          _mainClinic = _clinics[0].address ?? "No address available"; // Handle null address
          _mainClinicPhone = _clinics[0].phone ?? "N/A"; // Handle null phone
          if (_clinics.length > 1) {
            _branchClinic = _clinics[1].address ?? "No address available"; // Handle null address
            _branchClinicPhone = _clinics[1].phone ?? "N/A"; // Handle null phone
          }
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch clinics: $e";
      });
    }
  }

  Future<void> _fetchAvailableHours() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final token = tokenProvider.token; // Retrieve the token
    final apiService = DoctorAvailableHourAPIService(); // Use the correct API service

    try {
      final response = await apiService.getAvailableHours(token); // Fetch available hours
      setState(() {
        _availableHours = response.data.map((hour) => hour.availableHours).toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch available hours: $e";
      });
    }
  }

  Future<void> _chooseImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      final selectedFile = File(result.files.single.path!);

      // Update the local state with the selected image
      setState(() {
        _image = selectedFile;
      });

      // Fetch the token from the TokenProvider
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      final token = tokenProvider.token;

      // Call the API to upload the profile picture
      try {
        final apiService = DoctorApiService();
        final uploadResponse = await apiService.uploadProfilePicture(selectedFile, token);

        // Update the doctor's photo URL in the local state
        setState(() {
          if (_doctorInfo == null) {
            _doctorInfo = DoctorInfoModel(
              name: '', // Default values for other fields
              specialization: '',
              email: '',
              phone: '',
              totalRatings: 0, // Use a double value
              photo: uploadResponse.photoUrl, // Set the new photo URL
            );
          } else {
            _doctorInfo!.photo = uploadResponse.photoUrl; // Update the photo URL
          }
        });

        // Optionally, show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(uploadResponse.message)),
        );
      } catch (e) {
        // Handle the error (e.g., show a snackbar or dialog)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  void _showAddHourBottomSheet() {
    final TextEditingController textController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Available Hour',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Clinic and Day and Hours',
                  hintText: 'Clinic, Day, 10:00-12:00',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.isNotEmpty) {
                    // Add the hour locally
                    setState(() {
                      _availableHours.add(textController.text);
                    });

                    // Fetch the token from the TokenProvider
                    final tokenProvider =
                    Provider.of<TokenProvider>(context, listen: false);
                    final token = tokenProvider.token;

                    // Call the API to add the available hour
                    try {
                      final apiService = DoctoraddhoursApiService();
                      await apiService.addAvailableHours(token, textController.text);

                      // Optionally, you can fetch the updated hours from the API here
                      // For now, we assume the local state is sufficient
                    } catch (e) {
                      // Handle the error (e.g., show a snackbar or dialog)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add hour: $e')),
                      );
                    }

                    // Close the bottom sheet
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Hour'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _editClinicBottomSheet(String clinicType) {
    final TextEditingController locationController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    // Pre-fill the text fields with current values
    if (clinicType == 'Main Clinic') {
      locationController.text = _mainClinic;
      phoneController.text = _mainClinicPhone;
    } else {
      locationController.text = _branchClinic;
      phoneController.text = _branchClinicPhone;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit $clinicType Details',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone, // Ensures numeric keyboard
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (locationController.text.isNotEmpty &&
                      phoneController.text.isNotEmpty) {
                    setState(() {
                      if (clinicType == 'Main Clinic') {
                        _mainClinic = locationController.text;
                        _mainClinicPhone = phoneController.text;
                      } else {
                        _branchClinic = locationController.text;
                        _branchClinicPhone = phoneController.text;
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _chooseImage,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : _doctorInfo?.photo != null &&
                            _doctorInfo!.photo.isNotEmpty
                            ? NetworkImage(_doctorInfo!.photo)
                            : const AssetImage('assets/doctor.png')
                        as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${_doctorInfo?.name ?? 'Unknown'}',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _doctorInfo?.specialization ?? 'Specialization',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '⭐${_doctorInfo?.totalRatings?.toStringAsFixed(1) ?? '0.0'} ',
                            style: const TextStyle(fontSize: 14, color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          'Contact Info',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.email, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _doctorInfo?.email ?? 'No email provided',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.blueAccent),
                          const SizedBox(width: 8),
                          Text(
                            _doctorInfo?.phone ?? 'No phone provided',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'Available Hours',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableHours
                      .asMap()
                      .entries
                      .map(
                        (entry) => Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            entry.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _availableHours.removeAt(entry.key);
                              });
                            },
                            child: const Icon(
                              Icons.cancel,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Clinic Locations',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _editClinicBottomSheet('Main Clinic'),
                        child: ListTile(
                          title: const Text('Main Clinic',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_mainClinic), // Display Main Clinic address
                              Text('Phone: $_mainClinicPhone'), // Display Main Clinic phone
                            ],
                          ),
                          trailing: const Icon(Icons.edit),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _editClinicBottomSheet('Branch Clinic'),
                        child: ListTile(
                          title: const Text('Branch Clinic',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_branchClinic), // Display Branch Clinic address
                              Text('Phone: $_branchClinicPhone'), // Display Branch Clinic phone
                            ],
                          ),
                          trailing: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddHourBottomSheet,
          child: const Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }
}