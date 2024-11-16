import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/buttons.dart';
import 'package:feedback_app/emailverification.dart';
import 'package:feedback_app/mainloginpage.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String st2Username;
  final String st2UserRole;
  final String ppdname;
  ProfilePage({
    super.key,
    required this.st2Username,
    required this.st2UserRole,
    required this.ppdname,
  });
  _ProfilePageState createState() => _ProfilePageState(
      st2Usernamepp: st2Username,
      st2UserRolepp: st2UserRole,
      displayDept: ppdname);
}

class _ProfilePageState extends State<ProfilePage> {
  final String st2Usernamepp;
  final String st2UserRolepp;
  String displayDept;
  AppwriteService aspp = AppwriteService();
  _ProfilePageState(
      {required this.st2Usernamepp,
      required this.st2UserRolepp,
      required this.displayDept});
  String displayUserName = '';

  @override
  void initState() {
    super.initState();
    _fetchedName();
  }

  Future<void> _fetchedName() async {
    String nn = await aspp.getFullName(st2Usernamepp, st2UserRolepp);
    setState(() {
      displayUserName = nn;
    });
    print('displayname: $displayUserName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(
              color: Colors.white, // Change this to your desired font color
            )),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
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
              'Name: $displayUserName ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Display User ID based on User Role
            Text(
              st2UserRolepp.toLowerCase() == 'student'
                  ? 'Enrollment Number: $st2Usernamepp'
                  : 'User ID: $st2Usernamepp',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Department: $displayDept',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Clickable Text for Editing Password
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmailVerificationPage(
                            evusername: st2Usernamepp,
                            evUserRole: st2UserRolepp,
                          )),
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

            SizedBox(height: 20),

            // Logout Button at the Bottom
            Buttons(
                text: 'Logout',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginButtons()),
                  );
                })
          ],
        ),
      ),
    );
  }
}
