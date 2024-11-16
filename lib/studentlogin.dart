import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/studentdashboard.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StudentLoginPage extends StatelessWidget {
  final int sdeptid;
  final String sRole;
  final String dname;

  StudentLoginPage({
    required this.sdeptid,
    required this.sRole,
    required this.dname,
  });

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AppwriteService as = AppwriteService();
  bool _obscureText = true; // Variable to control password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            // Account Icon
            Icon(
              Icons.account_circle, // Built-in Flutter icon
              size: 150, // Adjust the size as needed
              color: Color(0xff2e73ae), // Match the app bar color
            ),
            SizedBox(height: 40),
            // Username TextField
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            // Password TextField with Eye Icon
            StatefulBuilder(
              builder: (context, setState) {
                return TextField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 19),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final String userName = usernameController.text;
                    final String passWord = passwordController.text;

                    final isValid = await as.verifyUserCredentials(
                        userName, passWord, sdeptid, sRole);

                    if (isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logged in Successfully')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Studentdashboard(
                            stdDept: sdeptid,
                            stUsername: userName,
                            stRole: sRole,
                            dnameSDashboard: dname,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid username or password')),
                      );
                    }
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
