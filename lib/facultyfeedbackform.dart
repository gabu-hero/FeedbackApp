import 'package:feedback_app/appwriteprovider.dart';
import 'package:flutter/material.dart';

class Facultyfeedbackform extends StatefulWidget {
  final int stdgfDept;
  Facultyfeedbackform({required this.stdgfDept});
  @override
  _FacultyfeedbackformState createState() =>
      _FacultyfeedbackformState(fffsdeptId: stdgfDept);
}

class _FacultyfeedbackformState extends State<Facultyfeedbackform> {
  final int fffsdeptId;
  _FacultyfeedbackformState({required this.fffsdeptId});
  // Controllers for input fields
  AppwriteService as = AppwriteService();
  final _programmeNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _courseTitleController = TextEditingController();
  final _suggestionsController = TextEditingController();
  Color buttoncolor = Color(0xff2e73ae);
  String? selectedFaculty;
  late final List<String> faculty = [];

  @override
  void initState() {
    _loadFaculty(); // Call the async method inside initState
  }

  Future<void> _loadFaculty() async {
    // Load the faculty asynchronously
    List<String> fetchedFaculty = await as.getFacultyByDepartment(fffsdeptId);
    setState(() {
      faculty = fetchedFaculty;
    });
  }

  // Variables to store feedback ratings
  Map<String, int?> facultyFeedback = {};
  Map<String, int?> courseOutcomeFeedback = {};
  Map<String, int?> facilitiesFeedback = {};

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.
    _programmeNameController.dispose();
    _courseCodeController.dispose();
    _courseTitleController.dispose();
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
            buildTextField('Programme Name:', _programmeNameController),
            buildTextField('Course Code:', _courseCodeController),
            buildTextField('Course Title:', _courseTitleController),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 12.0), // Adds padding of 12 below the text
              child: Text(
                'Faculty Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedFaculty,
              hint: Text('Select Faculty '),
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
                border:
                    OutlineInputBorder(), // Add border similar to text fields
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
              textAlign: TextAlign.left, // Align text to the left
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
            buildRatingSection('CO1', courseOutcomeFeedback),
            buildRatingSection('CO2', courseOutcomeFeedback),
            buildRatingSection('CO3', courseOutcomeFeedback),
            buildRatingSection('CO4', courseOutcomeFeedback),
            buildRatingSection('CO5', courseOutcomeFeedback),
            buildRatingSection('CO6', courseOutcomeFeedback),
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
                    // Logic to submit the form
                    print('Faculty Feedback: $facultyFeedback');
                    print('Course Outcome Feedback: $courseOutcomeFeedback');
                    print('Facilities Feedback: $facilitiesFeedback');
                    print('Suggestions: ${_suggestionsController.text}');
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
      {int maxLines = 5}) {
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
    List<String> ratingLabels = ['0', '5', '10'];

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
                    title: Text(ratingLabels[index]),
                    leading: Radio<int>(
                      value: index + 1,
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
}
