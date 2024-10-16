import 'package:feedback_app/buttons.dart';
import 'package:flutter/material.dart';


class Addcourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course', style: TextStyle(
            color: Colors.white, // Text color of the AppBar
          )),
        backgroundColor: Color(0xFF2E73AE), // AppBar color
      ),
      body: Container(
        color: Color(0xFFE7E7E7), // Background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Course Code'),
              buildTextField('Course Name'),
              buildTextField('Course Department'),
              buildTextField('CO1'),
              buildTextField('CO2'),
              buildTextField('CO3'),
              buildTextField('CO4'),
              buildTextField('CO5'),
              buildTextField('CO6'),
              buildTextField('CO7'),
              buildTextField('CO8'),
              SizedBox(height: 20), // Spacing at the bottom
              Center( // Center the button
                child: Buttons(text: 'Add', onPressed: () async { 

                 },)
              ),
            ],
          ),
        ),
      ),
    );
  }

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