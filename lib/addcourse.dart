import 'package:feedback_app/buttons.dart';
import 'package:flutter/material.dart';
import 'package:feedback_app/appwriteprovider.dart';

class Addcourse extends StatelessWidget {
  final String department;
  final int deptid; // Department id passed from the previous page
  Addcourse({required this.department, required this.deptid});
  final AppwriteService addCOU = AppwriteService();
  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController co1Controller = TextEditingController();
  final TextEditingController co2Controller = TextEditingController();
  final TextEditingController co3Controller = TextEditingController();
  final TextEditingController co4Controller = TextEditingController();
  final TextEditingController co5Controller = TextEditingController();
  final TextEditingController co6Controller = TextEditingController();
  final TextEditingController co7Controller = TextEditingController();
  final TextEditingController co8Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Course',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        backgroundColor: Color(0xFF2E73AE),
      ),
      body: Container(
        color: Color(0xFFE7E7E7),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTextField('Course Code', courseCodeController),
              buildTextField('Course Name', courseNameController),
              // Displaying department in a read-only TextField
              buildReadOnlyTextField('Department', department),
              buildTextField('Course Outcome 1', co1Controller),
              buildTextField('Course Outcome 2', co2Controller),
              buildTextField('Course Outcome 3', co3Controller),
              buildTextField('Course Outcome 4', co4Controller),
              buildTextField('Course Outcome 5', co5Controller),
              buildTextField('Course Outcome 6', co6Controller),
              buildTextField('Course Outcome 7', co7Controller),
              buildTextField('Course Outcome 8', co8Controller),
              SizedBox(height: 20),
              Center(
                child: Buttons(
                  text: 'Add',
                  onPressed: () async {
                    String cC = courseCodeController.text.trim();
                    String cN = courseNameController.text.trim();
                    String c1 = co1Controller.text.trim();
                    String c2 = co2Controller.text.trim();
                    String c3 = co3Controller.text.trim();
                    String c4 = co4Controller.text.trim();
                    String c5 = co5Controller.text.trim();
                    // ignore: unused_local_variable
                    String c6 = co6Controller.text.trim();
                    // ignore: unused_local_variable
                    String c7 = co7Controller.text.trim();
                    // ignore: unused_local_variable
                    String c8 = co8Controller.text.trim();
                    if (cC.isEmpty ||
                        cN.isEmpty ||
                        c1.isEmpty ||
                        c2.isEmpty ||
                        c3.isEmpty ||
                        c4.isEmpty ||
                        c5.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields!')),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Course added successfully!'),
                      ),
                    );
                    // Reset all controllers to clear the text fields
                    courseCodeController.clear();
                    courseNameController.clear();
                    co1Controller.clear();
                    co2Controller.clear();
                    co3Controller.clear();
                    co4Controller.clear();
                    co5Controller.clear();
                    co6Controller.clear();
                    co7Controller.clear();
                    co8Controller.clear();
                    print("Course added successfully!");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build a text field
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildReadOnlyTextField(String lable, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: TextEditingController(text: text), // Set initial text
        readOnly: true, // Make the TextField read-only
        decoration: InputDecoration(
          labelText: lable,
          border: OutlineInputBorder(),
          filled: true, // Optional: fill background to match other TextFields
          fillColor: Colors.grey[
              200], // Optional: background color for the read-only TextField
        ),
      ),
    );
  }
}
