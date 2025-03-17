import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/api/doctor_setting_api/edit_name.dart';
import 'package:collogefinalpoject/api/doctor_setting_api/edit_pasword.dart';
import 'package:collogefinalpoject/api/doctor_setting_api/logout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login/loginScreenDoctor.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
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

  Future<void> _updateName(String newName) async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final token = tokenProvider.token;

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a name.")),
      );
      return;
    }

    try {
      final apiService = DoctorAPIService_edit_name();
      final response = await apiService.editName(token, newName);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update name: $e")),
      );
    }
  }

  Future<void> _updatePassword() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final token = tokenProvider.token;

    final currentPassword = oldPasswordController.text.trim();
    final newPassword = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }

    try {
      final apiService = DoctorAPIService_edit_password();
      final response = await apiService.editPassword(
        token: token,
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: confirmPassword,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update password: $e")),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final token = tokenProvider.token;

    try {
      final apiService = DoctorAPIService_logout();
      final response = await apiService.logout(token);

      if (response.success) {
        // Clear the token when logging out
        tokenProvider.setToken('');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreenDoctor()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to logout: $e")),
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
                  _updateName(newName);
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email updated to: $newEmail")),
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
                          } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                            return 'Password should contain special characters';
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
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _updatePassword();
                          }
                        },
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Phone number updated")),
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
          ListTile(
            leading: Icon(Icons.exit_to_app, color: blueColor),
            title: const Text('Log Out'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TokenProvider()), // Provide TokenProvider
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SettingsPage(),
      ),
    ),
  );
}





