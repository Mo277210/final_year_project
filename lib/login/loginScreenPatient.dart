import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/shared_ui/customButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/login/loginResonseDm.dart'; // Ensure this import is correct
import '../homePagePatient/homePagePatient.dart';
import '../model/login/login_patient_model.dart'; // Ensure this import is correct
import '../shared_ui/chipRow.dart';

import '../shared_ui/nagelupbar.dart';
import '../signup/signUpScreenPatient.dart';
import 'loginScreenAdmin.dart';
import 'loginScreenDoctor.dart';

class LoginScreenPatient extends StatefulWidget {
  const LoginScreenPatient({super.key});

  @override
  _LoginScreenPatientState createState() => _LoginScreenPatientState();
}

class _LoginScreenPatientState extends State<LoginScreenPatient> {
  List<bool> isSelected = [true, false];
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _errorMessage = '';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    LoginRequestModel requestModel = LoginRequestModel(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      APIService apiService = APIService();
      var response = await apiService.login("patient", requestModel);

      print("Token Response: ${response.token}");

      if (response.token.isNotEmpty) {
        // Set the token in the TokenProvider
        Provider.of<TokenProvider>(context, listen: false).setToken(response.token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepagepatient()),
        );
      } else {
        setState(() {
          _errorMessage = response.error.isNotEmpty ? response.error : "Login failed. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please check your connection.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showAdminMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'admin',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Nagelupbar(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Welcome back',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 20),
                                ChipRow(
                                  chipNames: const ['Patient', 'Doctor'],
                                  onChipTap: [
                                    () {},
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreenDoctor()),
                                      );
                                    },
                                  ],
                                  isSelected: isSelected,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Color(0xFF105DFB),
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an email';
                                          } else if (!RegExp(
                                                  r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                              .hasMatch(value)) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isPasswordVisible =
                                                    !_isPasswordVisible;
                                              });
                                            },
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[300],
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a password';
                                          } else if (!RegExp(
                                                  r'[!@#$%^&*(),.?":{}|<>]')
                                              .hasMatch(value)) {
                                            return 'Password should contain special characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // Error Message Display
                                      if (_errorMessage.isNotEmpty)
                                        Text(
                                          _errorMessage,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        ),
                                      const SizedBox(height: 10),

                                      // Login Button
                                      CustomButton(
                                        buttonText: _isLoading
                                            ? 'Logging in...'
                                            : 'Log In',
                                        onPressed: _isLoading ? () {} : _login,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                color: Color(0xFF5A5C60),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignUpScreenPatient()),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Color(0xFF105DFB),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkWell(onTap: (){ Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreenAdmin()),
                        );},
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 12, 8, 12),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF105DFB),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.admin_panel_settings,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        size: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Admin',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreenPatient(),
  ));
}
