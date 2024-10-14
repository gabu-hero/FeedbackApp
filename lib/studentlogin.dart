import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/studentdashboard.dart';
import 'package:flutter/material.dart';

class StudentLoginPage extends StatelessWidget {
  final int sdeptid;
  final String sRole;

  StudentLoginPage({required this.sdeptid, required this.sRole});
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AppwriteService as = AppwriteService();

  @override
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
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
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
                  onPressed: () async {
                    final String userName = usernameController.text;
                    final String passWord = passwordController.text;

                    final isValid = await as.verifyUserCredentials(
                        userName, passWord, sdeptid, sRole);

                    if (isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logged in Successfully ')),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Studentdashboard(
                                  stdDept: sdeptid,
                                  stUsername: userName,
                                  stRole: sRole,
                                )),
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
