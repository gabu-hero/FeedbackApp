import 'package:feedback_app/facultyfeedbackform.dart';
import 'package:flutter/material.dart';

class StudentLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Login',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        centerTitle: false, // Align the title to the left
        backgroundColor: Color(0xff2e73ae),

        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            // Account Icon added by code
            Icon(
              Icons.account_circle, // Built-in Flutter icon
              size: 150, // Adjust the size as needed
              color: Color(0xff2e73ae), // Match the app bar color
            ),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Facultyfeedbackform()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff2e73ae),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white, // Set the text color to white
                      fontSize: 18, // Adjust font size if needed
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
