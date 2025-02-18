import 'package:flutter/material.dart';
import 'package:collogefinalpoject/homePageDoctor/homePageDoctor.dart';
import 'package:collogefinalpoject/login/loginScreenPatient.dart';
import 'package:collogefinalpoject/signup/signUPScreenDoctor.dart';
import '../api/SourceResponseDm.dart';
import '../model/login_patient_model.dart';
import '../signup/chipRow.dart';
import '../signup/customButton.dart';
import '../signup/nagelupbar.dart';


class LoginScreenDoctor extends StatefulWidget {
  const LoginScreenDoctor({super.key});

  @override
  _LoginScreenDoctorState createState() => _LoginScreenDoctorState();
}

class _LoginScreenDoctorState extends State<LoginScreenDoctor> {
  List<bool> isSelected = [false, true];
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Prevent multiple taps
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
      var response = await apiService.login("patient", requestModel); // Use "doctor"

      print("Token Response: ${response.token}");

      if (response.token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomepageDoctor()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Nagelupbar(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
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
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ChipRow(
                              chipNames: const ['Patient', 'Doctor'],
                              onChipTap: [
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreenPatient()),
                                  );
                                },
                                    () {},
                              ],
                              isSelected: isSelected,
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      labelStyle: const TextStyle(color: Colors.black),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an email';
                                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
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
                                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      labelStyle: const TextStyle(color: Colors.black),
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
                                  const SizedBox(height: 20),
                                  // Error Message Display
                                  if (_errorMessage.isNotEmpty)
                                    Text(
                                      _errorMessage,
                                      style: const TextStyle(color: Colors.red, fontSize: 14),
                                    ),
                                  const SizedBox(height: 10),

                                  // Login Button
                                  CustomButton(
                                    buttonText: _isLoading ? 'Logging in...' : 'Log In',
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
                              MaterialPageRoute(builder: (context) => const SignUpScreenDoctor()),
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

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreenDoctor(),
  ));
}



