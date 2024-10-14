import 'package:flutter/material.dart';

class EmailVerificationPage extends StatelessWidget {
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
                child: buildTextField('Enter Your Email'), // Center the text field
              ),
            ),
            // Spacer to push the button to the bottom
            SizedBox(
              width: 400, // Set the width of the button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2e73ae), // Button color
                  padding: EdgeInsets.symmetric(vertical: 15), // Button height
                ),
                onPressed: () {
                  // Handle submission
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16.0, // Text size
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Optional space at the bottom
          ],
        ),
      ),
    );
  }

  // Helper method to create input field
  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}