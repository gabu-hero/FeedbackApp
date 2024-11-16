import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/buttons.dart';
import 'package:feedback_app/passwordresetpage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EmailVerificationPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final String evusername;
  final String evUserRole;
  EmailVerificationPage({required this.evusername, required this.evUserRole});
  AppwriteService asev = AppwriteService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Email Verification',
          style: TextStyle(
            color: Colors.white, // Text color of the AppBar
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        backgroundColor: Color(0xFF2e73ae), // AppBar color
      ),
      body: Container(
        color: Color(0xFFE7E7E7), // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Expanded to push the TextField to the vertical center
            Expanded(
              child: Center(
                child: TextField(
                  controller:
                      emailController, // Use the controller you already defined
                  decoration: InputDecoration(
                    hintText: 'Enter Your Email', // Set the hint text here
                    border:
                        OutlineInputBorder(), // Optional: add a border to the TextField
                    filled: true, // Optional: add background color
                    fillColor: Colors.white, // Optional: background color
                  ),
                ),
                // Center the text field
              ),
            ),
            // Spacer to push the button to the bottom
            SizedBox(
              child: Buttons(
                text: 'Verify',
                onPressed: () async {
                  final recEmail = emailController.text;
                  final isValid =
                      await asev.verifyEmail(evusername, evUserRole, recEmail);

                  if (isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('E-mail Verification Successful ')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordResetPage(
                                prpuser: evusername,
                              )),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please Enter correct E-mail')),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20), // Optional space at the bottom
          ],
        ),
      ),
    );
  }
}
