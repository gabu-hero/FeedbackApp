import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/buttons.dart';
import 'package:feedback_app/profilepage.dart';
import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  final String prpuser;
  PasswordResetPage({required this.prpuser});
  @override
  _PasswordResetPageState createState() =>
      _PasswordResetPageState(rpuserID: prpuser);
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final String rpuserID;
  _PasswordResetPageState({required this.rpuserID});
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AppwriteService asrp = AppwriteService();
  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true; // To manage password visibility
  bool _obscureConfirmPassword = true; // To manage confirm password visibility

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      final isValid =
          await asrp.resetPassword(rpuserID, _passwordController.text);
      if (isValid) {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password successfully reset!'),
          ));
          // Reset form fields
          _passwordController.clear();
          _confirmPasswordController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      st2Username: '',
                      st2UserRole: '',
                      ppdname: '',
                    )),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password could not be reset!'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password Could not be reset!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.white), // AppBar text color
        ),
        backgroundColor: Color(0xff2e73ae), // AppBar background color
        iconTheme: IconThemeData(
            color: Colors.white), // Optional: if you have icons in the AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reset Your Password',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Password field with Eye icon
                  StatefulBuilder(
                    builder: (context, setState) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),

                  // Confirm Password field with Eye icon
                  StatefulBuilder(
                    builder: (context, setState) {
                      return TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),

                  // Error Message
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 10),

                  // Submit button
                  _isLoading
                      ? CircularProgressIndicator()
                      : Buttons(
                          text: 'Reset Password',
                          onPressed: _resetPassword,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
