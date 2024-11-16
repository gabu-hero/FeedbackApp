import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/buttons.dart';
import 'package:flutter/material.dart';

class AddFacultyPage extends StatelessWidget {
  final AppwriteService appwriteService = AppwriteService();
  final String department; // Department passed from the previous page
  final int deptid; // Department id passed from the previous page
  final String role;
  // Controllers for the input fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AddFacultyPage(
      {required this.department, required this.deptid, required this.role});

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
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        backgroundColor: Color(0xFF2E73AE), // AppBar color
      ),
      body: Container(
        color: Color(0xFFE7E7E7), // Background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField(usernameController, 'Enter Faculty Username'),
            buildTextField(nameController, 'Enter Faculty Name'),
            buildTextField(emailController, 'Enter Faculty Email'),
            // Displaying department in a read-only TextField
            buildReadOnlyTextField(department, 'Department'),
            buildTextField(passwordController, 'Create Password',
                isObscure: true),
            Spacer(), // Pushes the button to the bottom
            Center(
              child: SizedBox(
                child: Buttons(
                  text: 'Add',
                  onPressed: () async {
                    // Gather data from the input fields
                    String username = usernameController.text.trim();
                    String name = nameController.text.trim();
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    if (username.isEmpty ||
                        name.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Any field cannot be left empty')),
                      );
                    } else {
                      appwriteService.addUser(username, password, role);
                      // Call the addFaculty method from AppwriteService
                      String response = await appwriteService.addFaculty(
                        username,
                        name,
                        email,
                        deptid, // Use the passed department directly
                      );

                      // Show a message based on the response
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response)),
                      );
                      usernameController.clear();
                      nameController.clear();
                      emailController.clear();
                      passwordController.clear();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create input fields
  Widget buildTextField(TextEditingController controller, String label,
      {bool isObscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: isObscure, // Use obscure text for password
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Helper method to create a read-only TextField for the department
  Widget buildReadOnlyTextField(String text, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: TextEditingController(text: text), // Set initial text
        readOnly: true, // Make the TextField read-only
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true, // Optional: fill background to match other TextFields
          fillColor: Colors.grey[
              200], // Optional: background color for the read-only TextField
        ),
      ),
    );
  }
}
