import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/buttons.dart';
import 'package:flutter/material.dart';

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
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        backgroundColor: Color(0xff2e73ae), // Custom app bar color (optional)
      ),
      body: Center(
        child: Card(
          color: const Color(0xEBFFFFFF),
          elevation: 8,
          margin: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the faculty and course details
                Text(
                  'Faculty Name:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
                Text(
                  facultyName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Course Code:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
                Text(
                  courseCode,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Course Name:',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
                Text(
                  courseName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                // Button to trigger export
                Center(
                  child: Buttons(
                    text: 'Export as Excel',
                    onPressed: () async {
                      final isValid = await as.exportDataToExcel(
                          facultyName, courseCode, deptidep);

                      if (isValid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('File Exported Successfully')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error Exporting File')),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
