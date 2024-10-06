import 'package:feedback_app/buttons.dart';
import 'package:feedback_app/facultydepartment.dart';
import 'package:feedback_app/studentdepartment.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Mainloginpage());
}

class Mainloginpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginButtons(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF2E73AE),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.0), // Space between AppBar and content
              const Text(
                'Please select your login option:',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 20.0),
              Buttons(
                text: 'Login as Student',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DepartmentPageStudent()),
                  );
                },
              ),
              Buttons(
                text: 'Login as Faculty',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DepartmentPageFaculty()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
