import 'package:feedback_app/buttons.dart';
import 'package:feedback_app/mainloginpage.dart';
import 'package:feedback_app/passwordresetpage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(
              color: Colors.white, // Change this to your desired font color
            )),
        backgroundColor: Color(0xFF2E73AE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Person Icon in the Middle
            SizedBox(height: 40), // Top Padding
            Center(
              child: Icon(
                Icons.account_circle,
                size: 150,
                color: Color(0xFF2E73AE),
              ),
            ),
            SizedBox(height: 20), // Padding after icon

            // Display User Information
            Text(
              'Name: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Department: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Clickable Text for Editing Password
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordResetPage()),
                );
              },
              child: Text(
                'Edit Password',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            Spacer(), // Pushes logout button to the bottom

            // Logout Button at the Bottom
            Buttons(
                text: 'Logout',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Mainloginpage()),
                  );
                })
          ],
        ),
      ),
    );
  }
}
