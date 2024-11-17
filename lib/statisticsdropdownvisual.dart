import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/feedbackanalysispage.dart';
import 'package:flutter/material.dart';

class StatisticsDropdownVisual extends StatefulWidget {
  final String name;
  final int dept;
  StatisticsDropdownVisual({required this.name, required this.dept});
  _StatisticsDropdownVisualState createState() =>
      _StatisticsDropdownVisualState(sdvfacultyName: name, sdvdeptid: dept);
}

class _StatisticsDropdownVisualState extends State<StatisticsDropdownVisual> {
  final String sdvfacultyName;
  final int sdvdeptid;
  _StatisticsDropdownVisualState(
      {required this.sdvfacultyName, required this.sdvdeptid});
  List<Map<String, dynamic>> courses = [];
  AppwriteService assdv = AppwriteService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Map<String, dynamic>> fetchedCourses =
          await assdv.getCoursesByFacultyName(sdvfacultyName, sdvdeptid);
      List<Map<String, dynamic>> uniqueCourses = [];
      for (var course in fetchedCourses) {
        // Check if the combination of course_code and faculty_name already exists
        bool exists = uniqueCourses.any((element) =>
            element['course_code'] == course['course_code'] &&
            element['faculty_name'] == course['faculty_name']);
        if (!exists) {
          uniqueCourses.add(course);
        }
      }
      setState(() {
        courses = uniqueCourses;
        print('StatsDV : $courses'); // Debug output
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      appBar: AppBar(
        title: Text(
          'Course List',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        backgroundColor: Color(0xff2e73ae), // Custom app bar color (optional)
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              String sdvcourseCode = courses[index]['course_code']!;
              String sdvcourseName = courses[index]['course_name']!;

              // Navigate to the pie chart page directly
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackAnalysisPage(
                    facultyName: sdvfacultyName,
                    courseCode: sdvcourseCode,
                    deptid: sdvdeptid,
                    courseName: sdvcourseName,
                  ),
                ),
              );
            },
            child: Card(
              color: const Color(0xEBFFFFFF),
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              elevation: 3.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courses[index]['course_code']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      courses[index]['course_name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      courses[index]['faculty_name']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
