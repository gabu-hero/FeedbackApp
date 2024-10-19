import 'package:feedback_app/appwriteprovider.dart';
import 'package:feedback_app/feedbackanalysispage.dart';
import 'package:flutter/material.dart';

class StatisticsDropdownVisual extends StatefulWidget {
  final String name;
  StatisticsDropdownVisual({required this.name});
  _StatisticsDropdownVisualState createState() =>
      _StatisticsDropdownVisualState(sdvfacultyName: name);
}

class _StatisticsDropdownVisualState extends State<StatisticsDropdownVisual> {
  final String sdvfacultyName;
  _StatisticsDropdownVisualState({required this.sdvfacultyName});
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
          await assdv.getCoursesByFacultyName(sdvfacultyName);

      // Fix: Explicit type declaration
      Map<String, Map<String, dynamic>> uniqueCourses = {};

      for (var course in fetchedCourses) {
        uniqueCourses[course['course_code']] =
            course; // Use the course_code as the key
      }

      // Update state only once after processing
      setState(() {
        courses = uniqueCourses.values.toList();
        print(' StatsDV : $courses');
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
        backgroundColor: Color(0xff2e73ae), // Custom app bar color (optional)
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              String sdvcourseCode = courses[index]['course_code']!;
              // Navigate to the pie chart page directly
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackAnalysisPage(
                    facultyName: sdvfacultyName,
                    courseCode: sdvcourseCode,
                  ),
                ),
              );
            },
            child: Card(
              color: const Color(0xEBFFFFFF),
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0, ),
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
