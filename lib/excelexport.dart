import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/buttons.dart';
import 'package:flutter/material.dart';

// Package to get storage directory

class ExportPage extends StatelessWidget {
  final String facultyName;
  final String courseCode;
  final String courseName;
  final int deptidep;
  final AppwriteService as = AppwriteService();

  ExportPage(
      {required this.facultyName,
      required this.courseCode,
      required this.courseName,
      required this.deptidep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      appBar: AppBar(
        title: Text(
          'Export as Excel',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff2e73ae), // Custom app bar color (optional)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the faculty and course details as text
            SizedBox(height: 50),
            Text(
              'Faculty Name: $facultyName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Course Code: $courseCode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Course Name: $courseName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Button to trigger export
            Buttons(
                text: 'Export as Excel',
                onPressed: () async {
                  final isValid = await as.exportDataToExcel(
                      facultyName, courseCode, deptidep);

                  if (isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(' File Exported Successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error Exporting File')),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
