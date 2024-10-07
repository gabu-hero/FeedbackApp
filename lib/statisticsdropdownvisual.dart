import 'package:flutter/material.dart';

class StatisticsDropdownVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      appBar: AppBar(
        title: Text(
          'Courses List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff2e73ae),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CourseList(),
      ),
    );
  }
}

class CourseList extends StatelessWidget {
  final List<Map<String, String>> courses = [
    {'code': 'CS101', 'name': 'Introduction to Computer Science'},
    {'code': 'MATH201', 'name': 'Calculus I'},
    {'code': 'ENG110', 'name': 'English Composition'},
    {'code': 'PHYS101', 'name': 'Introduction to Physics'},
    {'code': 'CHEM101', 'name': 'General Chemistry'},
    // Add more courses as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Card(
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
        );
      },
    );
  }
}
