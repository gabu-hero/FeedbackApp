import 'package:feedback_app/appwriteprovider.dart';

import 'package:flutter/material.dart';

class Facultyfeedbackform extends StatefulWidget {
  final int stdgfDept;
  final String fffdname;
  final String enrollment_no;
  Facultyfeedbackform(
      {required this.stdgfDept,
      required this.fffdname,
      required this.enrollment_no});
  @override
  _FacultyfeedbackformState createState() => _FacultyfeedbackformState(
      fffsdeptId: stdgfDept, fffsdname: fffdname, enrollment_no: enrollment_no);
}

class _FacultyfeedbackformState extends State<Facultyfeedbackform> {
  final int fffsdeptId;
  final String fffsdname;
  final enrollment_no;
  _FacultyfeedbackformState(
      {required this.fffsdeptId,
      required this.fffsdname,
      required this.enrollment_no});
  // Controllers for input fields
  AppwriteService as = AppwriteService();
  final _programmeNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _suggestionsController = TextEditingController();

  Color buttoncolor = Color(0xff2e73ae);
  String? selectedFaculty;
  String? selectedCourse;
  String fetchedCourseName = '';

  late List<String> faculty = [];
  late List<String> courses = [];
  late List<String> courseOutcomes = [];

  @override
  void initState() {
    super.initState();
    _loadFaculty();
    _loadCourses();
    _programmeNameController.text =
        fffsdname; // Load courses based on department
  }

  Future<void> _loadFaculty() async {
    // Load the faculty asynchronously
    List<String> fetchedFaculty = await as.getFacultyByDepartment(fffsdeptId);
    setState(() {
      faculty = fetchedFaculty;
    });
  }

  Future<void> _loadCourses() async {
    // Load the courses asynchronously
    List<String> fetchedCourses = await as.getCoursesByDepartment(fffsdeptId);
    setState(() {
      courses =
          fetchedCourses.toList(); // Assume courses are strings (course names)
    });
  }

  Future<void> _loadCourseCode() async {
    String fetchedCourseCode =
        await as.getCourseCode(fetchedCourseName, fffsdeptId);
    print(fetchedCourseCode);
    setState(() {
      _courseCodeController.text =
          fetchedCourseCode; // Set the fetched course code
    });
    print(_courseCodeController.text);
  }

  Future<void> _loadCourseOutcomes() async {
    List<String> fetchedCourseOutcomes =
        await as.getCourseOutcomes(selectedCourse!, fffsdeptId);
    courseOutcomes = fetchedCourseOutcomes;

    setState(() {
      courseOutcomeFeedback = {for (var e in courseOutcomes) e: null};
    });
  }

  // Variables to store feedback ratings
  Map<String, int?> facultyFeedback = {};
  Map<String, int?> courseOutcomeFeedback = {};
  Map<String, int?> facilitiesFeedback = {};

  @override
  void dispose() {
    _programmeNameController.dispose();
    _courseCodeController.dispose();
    _suggestionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      appBar: AppBar(
        title: const Text(
          'Faculty Feedback Form',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff2e73ae),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'GOVERNMENT POLYTECHNIC, MUMBAI\n',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          '(AN AUTONOMOUS INSTITUTE OF GOVT. OF MAHARASHTRA)\n',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            buildTextField(
                'Programme Name:', enabled: false, _programmeNameController),

            // Course Name Dropdown
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Course Title:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedCourse,
              hint: Text('Select Course Name'),
              dropdownColor: Color(0xEBFFFFFF),
              onChanged: (String? newValue) async {
                setState(() async {
                  selectedCourse = newValue;
                  if (newValue != null) {
                    fetchedCourseName =
                        newValue; // Set the selected course name
                    await _loadCourseCode();
                    await _loadCourseOutcomes(); // Call the API to load the course code
                  }
                });
                fetchedCourseName = newValue!;
                print(fetchedCourseName);
              },
              items: courses.map<DropdownMenuItem<String>>((String course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(), // Add border similar to text fields
                filled: true,
                fillColor: const Color(0xEBFFFFFF),
              ),
            ),
            SizedBox(height: 20),
            buildTextField('Course Code:', _courseCodeController,
                enabled: false),

            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Faculty Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedFaculty,
              hint: Text('Select Faculty'),
              dropdownColor: Color(0xEBFFFFFF),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFaculty = newValue;
                });
              },
              items: faculty.map<DropdownMenuItem<String>>((String faculty) {
                return DropdownMenuItem<String>(
                  value: faculty,
                  child: Text(faculty),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xEBFFFFFF),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'Note: \nIn the below Rating Section;\n0 = Bad, 5 = Average, 10 = Good ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
              textAlign: TextAlign.left, // Align text to the left
            ),

            const SizedBox(height: 8),
            const Text(
              'Faculty Related Feedback',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            buildRatingSection(
                'Coverage of the course curriculum', facultyFeedback),
            buildRatingSection(
                'Competence and commitment of faculty', facultyFeedback),
            buildRatingSection(
                'Communication of faculty (oral/written)', facultyFeedback),
            buildRatingSection(
                'Pace of the content covered by the faculty', facultyFeedback),
            buildRatingSection(
                'Relevance of the Content of curriculum', facultyFeedback),

            const SizedBox(height: 20),
            const Text(
              'Course Outcomes Related',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (String outcome in courseOutcomes)
              buildRatingSection(outcome, courseOutcomeFeedback),
            const SizedBox(height: 20),
            const Text(
              'Facilities Related to the Course',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            buildRatingSection('Lab/infrastructure facility for the course',
                facilitiesFeedback),
            buildRatingSection('Availability of the reference books in library',
                facilitiesFeedback),

            const SizedBox(height: 20),
            buildTextField(
              'Suggestions for Improvement:',
              enabled: true,
              _suggestionsController,
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    print("Course Outcomes Length: ${courseOutcomes.length}");
                    print("Course Outcomes: $courseOutcomes");
                    print("Course Outcome Feedback: $courseOutcomeFeedback");

                    _submitFeedback();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttoncolor,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {int maxLines = 1, required bool enabled}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: enabled,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: maxLines,
            minLines: 1,
          ),
        ],
      ),
    );
  }

  Widget buildRatingSection(String title, Map<String, int?> feedbackMap) {
    List<int> ratingLabels = [0, 5, 10];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 4.0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Column(
                children: List.generate(3, (index) {
                  return ListTile(
                    title: Text(ratingLabels[index].toString()),
                    leading: Radio<int>(
                      value: ratingLabels[index],
                      groupValue: feedbackMap[title],
                      onChanged: (int? value) {
                        setState(() {
                          feedbackMap[title] = value;
                        });
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitFeedback() async {
    bool isAllowed =
        await as.canSubmitFeedback(enrollment_no, _courseCodeController.text);

    if (!isAllowed) {
      // Display a message indicating the student has reached the submission limit
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Limit Reached", style: TextStyle(color: Colors.red)),
            content: Text("You can only submit feedback twice for this course.",
                style: TextStyle(color: Colors.red)),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    Map<String, dynamic> feedbackData = {
      'dept_id': fffsdeptId,
      'feedback_course_name': selectedCourse, // From dropdown
      'feedback_course_code': _courseCodeController.text,
      'feedback_faculty_name': selectedFaculty, // From dropdown
      'frf1': facultyFeedback['Coverage of the course curriculum'],
      'frf2': facultyFeedback['Competence and commitment of faculty'],
      'frf3': facultyFeedback['Communication of faculty (oral/written)'],
      'frf4': facultyFeedback['Pace of the content covered by the faculty'],
      'frf5': facultyFeedback['Relevance of the Content of curriculum'],
      'co1_F': courseOutcomes.length > 0
          ? courseOutcomeFeedback[courseOutcomes[0]]
          : null,
      'co2_F': courseOutcomes.length > 1
          ? courseOutcomeFeedback[courseOutcomes[1]]
          : null,
      'co3_F': courseOutcomes.length > 2
          ? courseOutcomeFeedback[courseOutcomes[2]]
          : null,
      'co4_F': courseOutcomes.length > 3
          ? courseOutcomeFeedback[courseOutcomes[3]]
          : null,
      'co5_F': courseOutcomes.length > 4
          ? courseOutcomeFeedback[courseOutcomes[4]]
          : null,
      'co6_F': courseOutcomes.length > 5
          ? courseOutcomeFeedback[courseOutcomes[5]]
          : null,
      // Sixth course outcome
      'lab_infra':
          facilitiesFeedback['Lab/infrastructure facility for the course'],
      'library':
          facilitiesFeedback['Availability of the reference books in library'],
      'suggestion': _suggestionsController.text, // Suggestion text
      'enrollment_no': widget.enrollment_no,
    };
    try {
      await as.submitFeedback(feedbackData);
      // Show success message if feedback is submitted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
      print("Feedback submitted successfully!");
      _resetForm();
    } catch (e) {
      // Optionally handle error case and show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting feedback: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
      print("Error submitting feedback: $e");
    }
  }

  bool _validateForm() {
    // Check if course and faculty are selected
    if (selectedCourse == null || selectedCourse!.isEmpty) {
      _showErrorMessage('Please select a course.');
      return false;
    }
    if (selectedFaculty == null || selectedFaculty!.isEmpty) {
      _showErrorMessage('Please select a faculty.');
      return false;
    }
    // Check if all faculty feedback ratings are filled
    for (String key in facultyFeedback.keys) {
      if (facultyFeedback[key] == null) {
        _showErrorMessage('Please provide ratings for faculty feedback.');
        return false;
      }
    }

    // Check if all course outcome feedback ratings are filled
    for (String key in courseOutcomeFeedback.keys) {
      if (courseOutcomeFeedback[key] == null) {
        _showErrorMessage('Please provide ratings for course outcomes.');
        return false;
      }
    }

    // Check if facilities feedback ratings are filled
    for (String key in facilitiesFeedback.keys) {
      if (facilitiesFeedback[key] == null) {
        _showErrorMessage('Please provide ratings for facilities feedback.');
        return false;
      }
    }

    // All validations passed
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _resetForm() {
    setState(() {
      selectedCourse = null;
      selectedFaculty = null;
      _courseCodeController.clear();
      _suggestionsController.clear();
      facultyFeedback.clear();
      courseOutcomeFeedback.clear();
      facilitiesFeedback.clear();
      courseOutcomes.clear();
    });
  }
}
