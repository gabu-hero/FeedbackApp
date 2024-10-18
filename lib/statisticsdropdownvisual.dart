import 'package:flutter/material.dart';

class CourseList extends StatelessWidget {
  final List<Map<String, String>> courses = [
    {'code': 'CS101', 'name': 'Introduction to Computer Science'},
    {'code': 'MATH201', 'name': 'Calculus I'},
    {'code': 'ENG110', 'name': 'English Composition'},
    {'code': 'PHYS101', 'name': 'Introduction to Physics'},
    {'code': 'CHEM101', 'name': 'General Chemistry'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            String courseCode = courses[index]['code']!;
            // Navigate to the pie chart page directly
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoursePieChartPage(courseCode: courseCode),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courses[index]['code']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    courses[index]['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
