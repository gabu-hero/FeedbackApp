import 'package:flutter/material.dart';

class AddFacultyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Faculty',
          style: TextStyle(
            color: Colors.white, // Text color of the AppBar
          ),
        ),
        backgroundColor: Color(0xFF2E73AE), // AppBar color
      ),
      body: Container(
        color: Color(0xFFE7E7E7), // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('Enter Faculty username'),
            buildTextField('Enter Faculty Name'),
            buildTextField('Enter Faculty Email'),
            buildTextField('Enter Department'),
            buildTextField('Create Password'),
            Spacer(), // Pushes the button to the bottom
            Center(
              child: SizedBox(
                width: 400, // Set the width of the submit button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E73AE), // Button color
                    padding: EdgeInsets.symmetric(vertical: 15), // Optional height
                  ),
                  onPressed: () {
                    // Handle submission
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white, // Text color of the button
                      fontSize: 16.0, // Text size
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

  // Helper method to create input fields
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