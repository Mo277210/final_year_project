import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/api/patient_setting/Logout.dart';
import 'package:collogefinalpoject/api/patient_setting/editpassword.dart';
import 'package:collogefinalpoject/api/patient_setting/editphone.dart';
import 'package:collogefinalpoject/login/loginScreenPatient.dart';
import 'package:collogefinalpoject/model/patient_setting/editemail.dart';
import 'package:collogefinalpoject/model/patient_setting/editpassword.dart';
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isNameExpanded = false;
  bool isPasswordExpanded = false;
  bool isEmailExpanded = false;
  bool isPhoneExpanded = false;

  bool _isOldPasswordVisible = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final Color blueColor = Color(0xFF105DFB);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Add API service methods
  Future<void> _updateName() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final url = Uri.parse(
        'https://nagel-production.up.railway.app/api/patient/editName');

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
            SnackBar(
                content: Text(data['message'] ?? "Name updated successfully")),
          );
          nameController.clear(); // Clear the field after success
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

  Future<void> _updateEmail() async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter an email")),
      );
      return;
    }

    // Validate email format
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final request = PatientEmailRequest(email: emailController.text.trim());

    try {
      final response = await http.put(
        Uri.parse(
            'https://nagel-production.up.railway.app/api/patient/editEmail'),
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
        emailController.clear(); // Clear the field after success
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

        // Clear all password fields after successful update
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
        phoneController.clear(); // Clear field after success
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update phone: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          ExpansionTile(
            leading: Icon(Icons.person, color: blueColor),
            title: const Text('Change Name'),
            trailing: Icon(
              isNameExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) {
              setState(() {
                isNameExpanded = expanding;
              });
            },
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
                  String newName = nameController.text;
                  if (newName.isNotEmpty) {
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
          ExpansionTile(
            leading: Icon(Icons.email, color: blueColor),
            title: const Text('Change Email'),
            trailing: Icon(
              isEmailExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) {
              setState(() {
                isEmailExpanded = expanding;
              });
            },
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
                  String newEmail = emailController.text;
                  if (newEmail.isNotEmpty) {
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
          ExpansionTile(
            leading: Icon(Icons.lock, color: blueColor),
            title: const Text('Change Password'),
            trailing: Icon(
              isPasswordExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) {
              setState(() {
                isPasswordExpanded = expanding;
              });
            },
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
                            icon: Icon(
                              _isOldPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isOldPasswordVisible = !_isOldPasswordVisible;
                              });
                            },
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
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
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
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
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
          ExpansionTile(
            leading: Icon(Icons.phone, color: blueColor),
            title: const Text('Change Phone Number'),
            trailing: Icon(
              isPhoneExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: blueColor,
            ),
            onExpansionChanged: (bool expanding) {
              setState(() {
                isPhoneExpanded = expanding;
              });
            },
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
                  String newPhone = phoneController.text;
                  if (newPhone.isNotEmpty) {
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
          // In your ListTile for logout, update the onTap:
          ListTile(
            leading: Icon(Icons.exit_to_app, color: blueColor),
            title: const Text('Log Out'),
            onTap: () async {
              final tokenProvider =
                  Provider.of<TokenProvider>(context, listen: false);
              final logoutService =
                  PatientLogoutApiService(tokenProvider.token);

              try {
                // Show loading indicator
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

                // Close loading indicator
                Navigator.of(context).pop();

                if (response.success) {
                  // Clear the token
                  tokenProvider.clearToken();

                  // Navigate to login screen
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
                // Close loading indicator if still showing
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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TokenProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SettingPatientPage(),
      ),
    ),
  );
}
