import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/doctor_setting_api/edit_name.dart';
import '../api/doctor_setting_api/edit_pasword.dart';
import '../api/doctor_setting_api/edit_phone.dart';
import '../api/doctor_setting_api/logout.dart';
import '../api/doctor_setting_api/edit_email.dart';
import '../login/loginScreenDoctor.dart';
import '../model/doctor_setting_model/edit_email.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isNameExpanded = false;
  bool _isPasswordExpanded = false;
  bool _isEmailExpanded = false;
  bool _isPhoneExpanded = false;

  bool _isOldPasswordVisible = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final Color _blueColor = const Color(0xFF105DFB);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _updateName() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final newName = _nameController.text.trim();

    if (newName.isEmpty) {
      _showSnackBar("Please enter a name");
      return;
    }

    try {
      final response = await DoctorAPIService_edit_name().editName(
          tokenProvider.token,
          newName
      );

      _showSnackBar(response.message);
      if (response.success) {
        _nameController.clear();
        setState(() => _isNameExpanded = false);
      }
    } catch (e) {
      _showSnackBar("Failed to update name: $e");
    }
  }

  Future<void> _updateEmail() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final newEmail = _emailController.text.trim();

    if (newEmail.isEmpty) {
      _showSnackBar("Please enter an email");
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(newEmail)) {
      _showSnackBar("Please enter a valid email");
      return;
    }

    try {
      final response = await DoctorEditEmailAPIService().editEmail(
        token: tokenProvider.token,
        newEmail: newEmail,
        doctorId: _getDoctorId(), // Implement this method to get actual doctor ID
      );

      _showSnackBar(response.message);
      if (response.success) {
        _emailController.clear();
        setState(() => _isEmailExpanded = false);
      }
    } catch (e) {
      _showSnackBar("Failed to update email: $e");
    }
  }

  Future<void> _updatePassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);

    try {
      final response = await DoctorAPIService_edit_password().editPassword(
        token: tokenProvider.token,
        currentPassword: _oldPasswordController.text.trim(),
        newPassword: _passwordController.text.trim(),
        newPasswordConfirmation: _confirmPasswordController.text.trim(),
      );

      _showSnackBar(response.message);
      if (response.success) {
        _oldPasswordController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        setState(() => _isPasswordExpanded = false);
      }
    } catch (e) {
      _showSnackBar("Failed to update password: $e");
    }
  }

  Future<void> _updatePhone() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);
    final newPhone = _phoneController.text.trim();

    if (newPhone.isEmpty) {
      _showSnackBar("Please enter a phone number");
      return;
    }

    try {
      final response = await DoctorAPIService_edit_phone().editPhone(
        token: tokenProvider.token,
        newPhone: newPhone,
      );

      _showSnackBar(response.message);
      if (response.success) {
        _phoneController.clear();
        setState(() => _isPhoneExpanded = false);
      }
    } catch (e) {
      _showSnackBar("Failed to update phone: $e");
    }
  }

  Future<void> _logout() async {
    final tokenProvider = Provider.of<TokenProvider>(context, listen: false);

    try {
      final response = await DoctorAPIService_logout().logout(
          tokenProvider.token
      );

      if (response.success) {
        tokenProvider.setToken('');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreenDoctor()),
        );
      } else {
        _showSnackBar(response.message);
      }
    } catch (e) {
      _showSnackBar("Failed to logout: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  int _getDoctorId() {
    // Implement logic to get the current doctor's ID
    // This might come from your TokenProvider or another source
    return 0; // Replace with actual implementation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildNameTile(),
          _buildEmailTile(),
          _buildPasswordTile(),
          _buildPhoneTile(),
          _buildLogoutTile(),
        ],
      ),
    );
  }

  Widget _buildNameTile() {
    return ExpansionTile(
      leading: Icon(Icons.person, color: _blueColor),
      title: const Text('Change Name'),
      trailing: Icon(
        _isNameExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        color: _blueColor,
      ),
      onExpansionChanged: (expanding) => setState(() => _isNameExpanded = expanding),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _nameController,
            cursorColor: _blueColor,
            decoration: _inputDecoration('Enter new name'),
          ),
        ),
        _buildSaveButton(_updateName, 'Save Name'),
      ],
    );
  }

  Widget _buildEmailTile() {
    return ExpansionTile(
      leading: Icon(Icons.email, color: _blueColor),
      title: const Text('Change Email'),
      trailing: Icon(
        _isEmailExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        color: _blueColor,
      ),
      onExpansionChanged: (expanding) => setState(() => _isEmailExpanded = expanding),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _emailController,
            cursorColor: _blueColor,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('Enter new email'),
          ),
        ),
        _buildSaveButton(_updateEmail, 'Save Email'),
      ],
    );
  }

  Widget _buildPasswordTile() {
    return ExpansionTile(
      leading: Icon(Icons.lock, color: _blueColor),
      title: const Text('Change Password'),
      trailing: Icon(
        _isPasswordExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        color: _blueColor,
      ),
      onExpansionChanged: (expanding) => setState(() => _isPasswordExpanded = expanding),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildPasswordField(
                  controller: _oldPasswordController,
                  label: 'Old Password',
                  isVisible: _isOldPasswordVisible,
                  onVisibilityChanged: () => setState(() => _isOldPasswordVisible = !_isOldPasswordVisible),
                ),
                const SizedBox(height: 10),
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'New Password',
                  isVisible: _isPasswordVisible,
                  onVisibilityChanged: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a password';
                    if (value.length < 8) return 'Password must be at least 8 characters';
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return 'Include a special character';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  isVisible: _isConfirmPasswordVisible,
                  onVisibilityChanged: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                  validator: (value) {
                    if (value != _passwordController.text) return 'Passwords don\'t match';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _buildSaveButton(_updatePassword, 'Save Password'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneTile() {
    return ExpansionTile(
      leading: Icon(Icons.phone, color: _blueColor),
      title: const Text('Change Phone Number'),
      trailing: Icon(
        _isPhoneExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        color: _blueColor,
      ),
      onExpansionChanged: (expanding) => setState(() => _isPhoneExpanded = expanding),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _phoneController,
            cursorColor: _blueColor,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration('Enter new phone number'),
          ),
        ),
        _buildSaveButton(_updatePhone, 'Save Phone Number'),
      ],
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: Icon(Icons.exit_to_app, color: _blueColor),
      title: const Text('Log Out'),
      onTap: _logout,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityChanged,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      cursorColor: _blueColor,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _blueColor),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onVisibilityChanged,
        ),
        filled: true,
        fillColor: Colors.white,
        border: _inputBorder(),
        focusedBorder: _inputBorder(),
        enabledBorder: _inputBorder(),
      ),
    );
  }

  Widget _buildSaveButton(VoidCallback onPressed, String text) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: _blueColor),
        foregroundColor: _blueColor,
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: _blueColor),
      border: _inputBorder(),
      focusedBorder: _inputBorder(),
      enabledBorder: _inputBorder(),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: _blueColor),
    );
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TokenProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SettingsPage(),
      ),
    ),
  );
}