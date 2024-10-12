import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/buttons.dart';
import 'package:flutter/material.dart';
import 'studentlogin.dart';

class DepartmentPageStudent extends StatefulWidget {
  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPageStudent> {
  final AppwriteService as = AppwriteService();
  late int deptid;
  String? selectedDepartment;
  final List<String> departments = [
    'Civil Engineering',
    'Computer Engineering',
    'Electrical Engineering',
    'Electronics Engineering',
    'Information Technology',
    'Instrumentation Engineering',
    'Mechanical Engineering',
    'Leather Technology',
    'Leather Goods and Footwear Technology',
    'Rubber Technology',
    'Artificial Intelligence and Machine Learning',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      appBar: AppBar(
        title: Text(
          'Department Selection',
          style: TextStyle(
            color: Colors.white, // Change this to your desired font color
          ),
        ),
        backgroundColor: Color(0xFF2E73AE),
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center the icon horizontally
        children: [
          SizedBox(height: 130), // 100px space after the AppBar
          Center(
            child: Icon(
              Icons.account_balance, // Buildings icon
              size: 150.0, // Make the icon bigger
              color: Color(0xFF2E73AE), // Match the icon color with your theme
            ),
          ),
          SizedBox(height: 70), // 60px space between the icon and the text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Select your department:',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedDepartment,
                    hint: Text('Select Department '),
                    onChanged: (String? nValue) {
                      setState(() async {
                        selectedDepartment = nValue.toString();
                      });
                    },
                    items: departments
                        .map<DropdownMenuItem<String>>((String department) {
                      return DropdownMenuItem<String>(
                        value: department,
                        child: Text(department),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(), // Add border similar to text fields
                      filled: true,
                      fillColor: const Color(0xEBFFFFFF),
                    ),
                  ),
                  SizedBox(height: 55),
                  Buttons(
                    text: 'Submit',
                    onPressed: () async {
                      print(selectedDepartment);
                      deptid =
                          await as.getDepartmentIdByName(selectedDepartment);
                      print(deptid);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StudentLoginPage(sdeptid: deptid)),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
