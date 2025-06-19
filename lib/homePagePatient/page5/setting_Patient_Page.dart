import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/api/patient_setting/EditBirthdate.dart';
import 'package:collogefinalpoject/api/patient_setting/Logout.dart';
import 'package:collogefinalpoject/api/patient_setting/editAddress.dart';
import 'package:collogefinalpoject/api/patient_setting/editpassword.dart';
import 'package:collogefinalpoject/api/patient_setting/editphone.dart';
import 'package:collogefinalpoject/login/loginScreenPatient.dart';
import 'package:collogefinalpoject/model/patient_setting/editemail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingPatientPage extends StatefulWidget {
  const SettingPatientPage({Key? key}) : super(key: key);

  @override
  _SettingPatientPageState createState() => _SettingPatientPageState();
}

class _SettingPatientPageState extends State<SettingPatientPage> {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Expansion states
  bool isNameExpanded = false;
  bool isPasswordExpanded = false;
  bool isEmailExpanded = false;
  bool isPhoneExpanded = false;
  bool isBirthdateExpanded = false;
  bool isAddressExpanded = false;

  // Password visibility
  bool _isOldPasswordVisible = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final Color blueColor = Color(0xFF105DFB);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Update Name
  Future<void> _updateName() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final url = Uri.parse('https://nagel-production.up.railway.app/api/patient/editName');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer ${tokenProvider.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({'name': nameController.text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Name updated successfully")),
          );
          nameController.clear();
        } else {
          throw Exception(data['message'] ?? "Failed to update name");
        }
      } else {
        throw Exception("Failed to update name: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // Update Email
  Future<void> _updateEmail() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter an email")),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final request = PatientEmailRequest(email: emailController.text.trim());

    try {
      final response = await http.put(
        Uri.parse('https://nagel-production.up.railway.app/api/patient/editEmail'),
        headers: {
          'Authorization': 'Bearer ${tokenProvider.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      final responseData = json.decode(response.body);
      final emailResponse = PatientEmailResponse.fromJson(responseData);

      if (response.statusCode == 200 && emailResponse.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(emailResponse.message)),
        );
        emailController.clear();
      } else {
        throw Exception(emailResponse.message);
      }
    } on http.ClientException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: ${e.message}")),
      );
    } on FormatException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid server response")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update email: ${e.toString()}")),
      );
    }
  }

  // Update Password
  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final passwordService = PatientEditPasswordApiService(tokenProvider.token);

    try {
      final response = await passwordService.changePassword(
        currentPassword: oldPasswordController.text,
        newPassword: passwordController.text,
        newPasswordConfirmation: confirmPasswordController.text,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        oldPasswordController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update password: ${e.toString()}")),
      );
    }
  }

  // Update Phone
  Future<void> _updatePhone() async {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a phone number")),
      );
      return;
    }

    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final phoneService = PatientEditPhoneApiService(tokenProvider.token);

    try {
      final response = await phoneService.updatePhone(phoneController.text);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        phoneController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update phone: ${e.toString()}")),
      );
    }
  }

  // Update Birthdate
  Future<void> _updateBirthdate() async {
    if (birthdateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a birthdate")),
      );
      return;
    }

    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final apiService = ApiEditBirthdate();

    try {
      final response = await apiService.updateBirthdate(
        token: tokenProvider.token,
        dob: birthdateController.text,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        birthdateController.clear();
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update birthdate: ${e.toString()}")),
      );
    }
  }

  // Update Address
  Future<void> _updateAddress() async {
    if (addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter an address")),
      );
      return;
    }

    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final apiService = ApiEditAddress();

    try {
      final response = await apiService.updatePatientAddress(
        token: tokenProvider.token,
        address: addressController.text,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
        addressController.clear();
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update address: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // Name Section
          ExpansionTile(
            leading: Icon(Icons.person, color: blueColor),
            title: const Text('Change Name'),
            trailing: Icon(
              isNameExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) =>
                setState(() => isNameExpanded = expanding),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: nameController,
                  cursorColor: blueColor,
                  decoration: InputDecoration(
                    labelText: 'Enter new name',
                    labelStyle: TextStyle(color: blueColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    _updateName();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a name")),
                    );
                  }
                },
                child: const Text('Save Name'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: blueColor),
                  foregroundColor: blueColor,
                ),
              ),
            ],
          ),

          // Email Section
          ExpansionTile(
            leading: Icon(Icons.email, color: blueColor),
            title: const Text('Change Email'),
            trailing: Icon(
              isEmailExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) =>
                setState(() => isEmailExpanded = expanding),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: emailController,
                  cursorColor: blueColor,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Enter new email',
                    labelStyle: TextStyle(color: blueColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    _updateEmail();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter an email")),
                    );
                  }
                },
                child: const Text('Save Email'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: blueColor),
                  foregroundColor: blueColor,
                ),
              ),
            ],
          ),

          // Password Section
          ExpansionTile(
            leading: Icon(Icons.lock, color: blueColor),
            title: const Text('Change Password'),
            trailing: Icon(
              isPasswordExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) =>
                setState(() => isPasswordExpanded = expanding),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: oldPasswordController,
                        obscureText: !_isOldPasswordVisible,
                        cursorColor: blueColor,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          labelStyle: TextStyle(color: blueColor),
                          suffixIcon: IconButton(
                            icon: Icon(_isOldPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() => _isOldPasswordVisible =
                            !_isOldPasswordVisible),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blueColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blueColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blueColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your old password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        cursorColor: blueColor,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: TextStyle(color: blueColor),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() => _isPasswordVisible =
                            !_isPasswordVisible),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blueColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blueColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blueColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                              .hasMatch(value)) {
                            return 'Password should contain special characters';
                          } else if (value.length < 8) {
                            return 'Password should be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        cursorColor: blueColor,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: blueColor),
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() =>
                            _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blueColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blueColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: blueColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _updatePassword,
                        child: const Text('Save Password'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: blueColor),
                          foregroundColor: blueColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Phone Section
          ExpansionTile(
            leading: Icon(Icons.phone, color: blueColor),
            title: const Text('Change Phone Number'),
            trailing: Icon(
              isPhoneExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) =>
                setState(() => isPhoneExpanded = expanding),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: phoneController,
                  cursorColor: blueColor,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Enter new phone number',
                    labelStyle: TextStyle(color: blueColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (phoneController.text.isNotEmpty) {
                    _updatePhone();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a phone number")),
                    );
                  }
                },
                child: const Text('Save Phone Number'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: blueColor),
                  foregroundColor: blueColor,
                ),
              ),
            ],
          ),

          // Birthdate Section
          ExpansionTile(
            leading: Icon(Icons.cake, color: blueColor),
            title: const Text('Change Birthdate'),
            trailing: Icon(
              isBirthdateExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) =>
                setState(() => isBirthdateExpanded = expanding),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: birthdateController,
                  readOnly: true, // لمنع التعديل اليدوي
                  cursorColor: blueColor,
                  decoration: InputDecoration(
                    labelText: 'Enter new birthdate (YYYY-MM-DD)',
                    labelStyle: TextStyle(color: blueColor),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today, color: blueColor),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          // تنسيق التاريخ بصيغة YYYY-MM-DD
                          String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          setState(() {
                            birthdateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _updateBirthdate,
                child: const Text('Save Birthdate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: blueColor),
                  foregroundColor: blueColor,
                ),
              ),
            ],
          ),


          // Address Section
          ExpansionTile(
            leading: Icon(Icons.home, color: blueColor),
            title: const Text('Change Address'),
            trailing: Icon(
              isAddressExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) =>
                setState(() => isAddressExpanded = expanding),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: addressController,
                  cursorColor: blueColor,
                  decoration: InputDecoration(
                    labelText: 'Enter new address',
                    labelStyle: TextStyle(color: blueColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _updateAddress,
                child: const Text('Save Address'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: blueColor),
                  foregroundColor: blueColor,
                ),
              ),
            ],
          ),

          // Logout Section
          ListTile(
            leading: Icon(Icons.exit_to_app, color: blueColor),
            title: const Text('Log Out'),
            onTap: () async {
              final tokenProvider =
              Provider.of<TokenProvider>(context, listen: false);
              final logoutService = PatientLogoutApiService(tokenProvider.token);
              try {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                final response = await logoutService.logout();
                Navigator.of(context).pop();
                if (response.success) {
                  tokenProvider.clearToken();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreenPatient()),
                        (Route<dynamic> route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.message)),
                  );
                }
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}