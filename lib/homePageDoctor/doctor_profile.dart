import 'dart:convert';
import 'dart:io';
import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/api/doctor_home/AvailableHour.dart';
import 'package:collogefinalpoject/api/doctor_home/EditClinic.dart';
import 'package:collogefinalpoject/api/doctor_home/add_clinic.dart';
import 'package:collogefinalpoject/api/doctor_home/addhourse.dart';
import 'package:collogefinalpoject/api/doctor_home/edithour.dart';
import 'package:collogefinalpoject/api/doctor_home/sendimage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/doctor_home/doctor_home_api.dart';
import '../model/doctor_home/doctor_home_model.dart';
import '../api/doctor_home/show_clinc.dart';
import '../model/doctor_home/show_clinc.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({Key? key}) : super(key: key);

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  File? _image;
  List<String> _availableHours = [];
  String _mainClinic = "No main clinic available";
  String _mainClinicPhone = "N/A";
  String _branchClinic = "No branch clinic available";
  String _branchClinicPhone = "N/A";
  DoctorInfoModel? _doctorInfo;
  bool _isLoading = true;
  String _errorMessage = '';
  List<showClinic> _clinics = [];
  List<int> id_schedule = []; // Declare id_schedule as a class variable
  List<int> clinic_id = []; // New list to store clinic IDs

  @override
  void initState() {
    super.initState();
    _fetchDoctorInfo();
    _fetchClinics();
    _fetchAvailableHours();
  }
  void _launchURL(String url) async {
    print('Trying to launch: $url');
    final uri = Uri.tryParse(url.trim());
    if (uri == null || uri.scheme.isEmpty || !['http', 'https'].contains(uri.scheme)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid URL: $url')),
      );
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to launch URL: $url')),
      );
    }
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
    final token = tokenProvider.token;
    final clinicApiService = ClinicApiService();
    try {
      final clinics = await clinicApiService.getClinics(token);
      final clinicIds =
          clinics.map((clinic) => clinic.id).toList(); // Extract clinic IDs
      setState(() {
        _clinics = clinics;
        clinic_id = clinicIds; // Save clinic IDs to clinic_id list
        _updateClinicDisplay();
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to fetch clinics: $e";
        _updateClinicDisplay(); // Ensure we still update with default values
      });
    }
  }

  void _updateClinicDisplay() {
    if (_clinics.isEmpty) {
      setState(() {
        _mainClinic = "No main clinic available";
        _mainClinicPhone = "N/A";
        _branchClinic = "No branch clinic available";
        _branchClinicPhone = "N/A";
      });
    } else {
      setState(() {
        // Find main clinic (assuming it's the first one or has a specific type)
        _mainClinic = _clinics[0].address ?? "No address available";
        _mainClinicPhone = _clinics[0].phone ?? "N/A";
        // Find branch clinic if available
        if (_clinics.length > 1) {
          _branchClinic = _clinics[1].address ?? "No address available";
          _branchClinicPhone = _clinics[1].phone ?? "N/A";
        } else {
          _branchClinic = "No branch clinic available";
          _branchClinicPhone = "N/A";
        }
      });
    }
  }

  Future<void> _fetchAvailableHours() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final token = tokenProvider.token;
    final apiService = DoctorAvailableHourAPIService();
    try {
      final response = await apiService.getAvailableHours(token);
      setState(() {
        _availableHours =
            response.data.map((hour) => hour.availableHours).toList();
        id_schedule = response.data.map((hour) => hour.id).toList();
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
      setState(() {
        _image = selectedFile;
      });
      final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
      final token = tokenProvider.token;
      try {
        final apiService = DoctorApiService();
        final uploadResponse =
            await apiService.uploadProfilePicture(selectedFile, token);
        setState(() {
          if (_doctorInfo == null) {
            _doctorInfo = DoctorInfoModel(
              name: '',
              specialization: '',
              email: '',
              phone: '',
              totalRatings: 0,
              photo: uploadResponse.photoUrl,
            );
          } else {
            _doctorInfo!.photo = uploadResponse.photoUrl;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(uploadResponse.message)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  void _addAddHourBottomSheet() {
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
                decoration: InputDecoration(
                  labelText: 'Clinic and Day and Hours',
                  hintText: 'Clinic, Day, 10:00-12:00',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      textController.clear();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.isNotEmpty) {
                    final tokenProvider =
                        Provider.of<TokenProvider>(context, listen: false);
                    final token = tokenProvider.token;
                    try {
                      final apiService = DoctoraddhoursApiService();
                      await apiService.addAvailableHours(
                          token, textController.text);
                      await _fetchAvailableHours();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hour added successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add hour: $e')),
                      );
                    } finally {
                      Navigator.pop(context);
                    }
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

  void _editHourBottomSheet(int index, int scheduleId) {
    final TextEditingController textController = TextEditingController();
    textController.text = _availableHours[index];
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
                'Edit Available Hour',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Clinic and Day and Hours',
                  hintText: 'Clinic, Day, 10:00-12:00',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      textController.clear();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.isNotEmpty) {
                    setState(() {
                      _availableHours[index] = textController.text;
                    });
                    final tokenProvider =
                        Provider.of<TokenProvider>(context, listen: false);
                    final token = tokenProvider.token;
                    try {
                      final apiService = edithourseDoctorApiService();
                      await edithourseDoctorApiService.editAvailableHours(
                        scheduleId: scheduleId,
                        availableHours: textController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Successfully updated hour')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to edit hour: $e')),
                      );
                    }
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

  void _add_and_editClinicBottomSheet(String clinicType) {
    bool isMainClinic = clinicType.toLowerCase().contains('main');
    bool hasClinic = isMainClinic ? clinic_id.isNotEmpty : clinic_id.length > 1;

    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    if (hasClinic) {
      int clinicIndex = isMainClinic ? 0 : 1;
      int clinicId = clinic_id[clinicIndex];
      var clinic = _clinics.firstWhere((c) => c.id == clinicId);
      nameController.text = clinic.name ?? '';
      addressController.text = clinic.address ?? '';
      phoneController.text = clinic.phone ?? '';
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
                hasClinic ? 'Edit $clinicType Details' : 'Add $clinicType',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => addressController.clear(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => phoneController.clear(),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 5),
              const Text(
                'You can leave the fields empty to clear the data. '
                    'If a phone number is entered, it must be exactly 11 digits.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final tokenProvider =
                        Provider.of<TokenProvider>(context, listen: false);
                    final token = tokenProvider.token;

                    if (hasClinic) {
                      int clinicIndex = isMainClinic ? 0 : 1;
                      int clinicId = clinic_id[clinicIndex];

                      final apiService = EditClinicAPI();
                      final response = await apiService.editClinic(
                        clinicId: clinicId,
                        token: token,
                        name: nameController.text,
                        address: addressController.text,
                        phone: phoneController.text,
                      );

                      if (response != null && response.success) {
                        await _fetchClinics();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update clinic')),
                        );
                      }
                    } else {
                      final apiService =
                          DoctorAddClinicApiService(tokenProvider);
                      final response = await apiService.addClinic(
                        clinicType,
                        addressController.text,
                        phoneController.text,
                      );

                      if (response.success) {
                        await _fetchClinics();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed: ${response.message}')),
                        );
                      }
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  } finally {
                    Navigator.pop(context);
                  }
                },
                child: Text(hasClinic ? 'Save Changes' : 'Add Clinic'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _deleteHourBottomSheet(int index, int scheduleId) {
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
                'Delete Available Hour',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Are you sure you want to delete this hour?',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final tokenProvider =
                            Provider.of<TokenProvider>(context, listen: false);
                        final token = tokenProvider.token;
                        if (token.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Authentication token is missing. Please log in again.')),
                          );
                          Navigator.pop(context);
                          return;
                        }
                        final apiService = DoctorAvailableHourAPIService();
                        final deleteResponse =
                            await apiService.deleteAvailableHour(
                          id: scheduleId,
                          token: token,
                        );
                        if (deleteResponse.success) {
                          setState(() {
                            _availableHours.removeAt(index);
                            id_schedule.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(deleteResponse.message)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Failed to delete hour: ${deleteResponse.message}'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting hour: $e')),
                        );
                      } finally {
                        Navigator.pop(context);
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
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
                                          Uri.tryParse(_doctorInfo!.photo)
                                                  ?.hasScheme ==
                                              true &&
                                          Uri.tryParse(_doctorInfo!.photo)
                                                  ?.hasAuthority ==
                                              true
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
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _doctorInfo?.specialization ??
                                      'Specialization',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '⭐${_doctorInfo?.totalRatings?.toStringAsFixed(1) ?? '0.0'} ',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.orange),
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
                                const Icon(Icons.email,
                                    color: Colors.blueAccent),
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
                                const Icon(Icons.phone,
                                    color: Colors.blueAccent),
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
                                        _editHourBottomSheet(
                                            entry.key, id_schedule[entry.key]);
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        _deleteHourBottomSheet(
                                            entry.key, id_schedule[entry.key]);
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
                              onTap: () =>
                                  _add_and_editClinicBottomSheet('Main '),
                              child:ListTile(
                                title: const Text(
                                  'Main Clinic',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Check if _mainClinic is a valid URL and launch it
                                        if (_mainClinic.startsWith("http://") || _mainClinic.startsWith("https://")) {
                                          _launchURL(_mainClinic);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('$_mainClinic is not a valid URL')),
                                          );
                                        }
                                      },
                                      child: Text(
                                        _mainClinic,
                                        style: TextStyle(
                                          color: _mainClinic.startsWith("http://") || _mainClinic.startsWith("https://")
                                              ? Colors.blue
                                              : null, // Make it blue if it's a URL
                                          decoration: _mainClinic.startsWith("http://") || _mainClinic.startsWith("https://")
                                              ? TextDecoration.underline
                                              : null, // Underline if it's a URL
                                        ),
                                      ),
                                    ),
                                    Text('Phone: $_mainClinicPhone'),
                                  ],
                                ),
                                trailing: const Icon(Icons.edit),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  _add_and_editClinicBottomSheet('Branch '),
                              child: ListTile(
                                title: const Text(
                                  'Branch Clinic',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Check if _branchClinic is a valid URL and launch it
                                        if (_branchClinic.startsWith("http://") || _branchClinic.startsWith("https://")) {
                                          _launchURL(_branchClinic);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('$_branchClinic is not a valid URL')),
                                          );
                                        }
                                      },
                                      child: Text(
                                        _branchClinic,
                                        style: TextStyle(
                                          color: _branchClinic.startsWith("http://") || _branchClinic.startsWith("https://")
                                              ? Colors.blue
                                              : null, // Make it blue if it's a URL
                                          decoration: _branchClinic.startsWith("http://") || _branchClinic.startsWith("https://")
                                              ? TextDecoration.underline
                                              : null, // Underline if it's a URL
                                        ),
                                      ),
                                    ),
                                    Text('Phone: $_branchClinicPhone'),
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
          onPressed: _addAddHourBottomSheet,
          child: const Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
