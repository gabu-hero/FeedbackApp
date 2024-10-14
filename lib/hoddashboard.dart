import 'package:feedback_app/addcourse.dart';
import 'package:feedback_app/addfaculty.dart';
import 'package:feedback_app/dashboardbutton.dart';
import 'package:flutter/material.dart';

class HodDashboard extends StatelessWidget {
  final Color customcolor1 = const Color(0xff2e73ae);
  final Color customcolor2 = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      appBar: AppBar(
        title: Text(
          'HOD Dashboard',
          style: TextStyle(
            color: customcolor2,
          ),
        ),
        centerTitle: false,
        backgroundColor: customcolor1,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Wrap everything in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 500,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                  physics:
                      NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  shrinkWrap: true, // Wraps the grid to its contents
                  children: [
                    DashboardButton(
                      label: 'View Feedback',
                      icon: Icons.note_alt,
                      color: customcolor1,
                      onPressed: () {
                        // Add functionality here
                      },
                    ),
                    DashboardButton(
                      label: 'View Feedback Graphically',
                      icon: Icons.bar_chart,
                      color: customcolor1,
                      onPressed: () {
                        // Add functionality here
                      },
                    ),
                    DashboardButton(
                        label: 'Profile',
                        icon: Icons.person,
                        color: customcolor1,
                        onPressed: () {}),
                    DashboardButton(
                        label: 'Add Faculty',
                        icon: Icons.person_add,
                        color: customcolor1,
                        onPressed: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddFacultyPage()),
                              );
                        }),
                    DashboardButton(
                        label: 'Add Courses',
                        icon: Icons.book,
                        color: customcolor1,
                        onPressed: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Addcourse()),
                        );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
