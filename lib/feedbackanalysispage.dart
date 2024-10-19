import 'package:feedback_app/appwriteprovider.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class FeedbackAnalysisPage extends StatefulWidget {
  final String courseCode;
  final String facultyName;
  final int deptid;
  final String courseName;

  FeedbackAnalysisPage(
      {required this.facultyName,
      required this.courseCode,
      required this.deptid,
      required this.courseName});

  @override
  _FeedbackAnalysisPageState createState() => _FeedbackAnalysisPageState(
      fapsfacultyName: facultyName,
      fapscourseCode: courseCode,
      fapsdeptID: deptid,
      fapscourseName: courseName);
}

class _FeedbackAnalysisPageState extends State<FeedbackAnalysisPage> {
  final String fapscourseCode;
  final String fapsfacultyName;
  final int fapsdeptID;
  final String fapscourseName;

  _FeedbackAnalysisPageState(
      {required this.fapsfacultyName,
      required this.fapscourseCode,
      required this.fapsdeptID,
      required this.fapscourseName});

  List<Map<String, dynamic>> feedbackData = [];
  List<String> feedbackColumns = [
    'frf1',
    'frf2',
    'frf3',
    'frf4',
    'frf5',
    'co1_F',
    'co2_F',
    'co3_F',
    'co4_F',
    'co5_F',
    'co6_F',
    'lab_infra',
    'library'
  ];
  List<String> staticquestion1 = [
    'Coverage of the course curriculum',
    'Competence and commitment of faculty',
    'Communication of faculty (oral/written)',
    'Pace of the content covered by the faculty',
    'Relevance of the Content of curriculum',
  ];
  List<String> staticquestions2 = [
    'Lab/infrastructure facility for the course',
    'Availability of the reference books in library'
  ];
  List<String> questions = [];
  AppwriteService as = AppwriteService();

  @override
  void initState() {
    super.initState();
    loadFeedbackData();
    loadCourseOutcomes();
  }

  void loadFeedbackData() async {
    List<Map<String, dynamic>> data =
        await as.getFeedbackForCourse(fapsfacultyName, fapscourseCode);
    setState(() {
      feedbackData = data;
    });
  }

  void loadCourseOutcomes() async {
    List<String> cOutcomes =
        await as.getCourseOutcomes(fapscourseName, fapsdeptID);
    print(cOutcomes);
    setState(() {
      questions = [...staticquestion1, ...cOutcomes, ...staticquestions2];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      appBar: AppBar(
        title: Text(
          'Feedback Analysis',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff2e73ae),
      ),
      body: feedbackData.isNotEmpty && questions.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, // Single column per row
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.0, // Square aspect ratio
                    ),
                    itemCount: feedbackColumns.length,
                    itemBuilder: (context, index) {
                      String column = feedbackColumns[index];
                      if (index >= questions.length) {
                        return Center(child: Text('Loading...'));
                      }
                      Map<String, int> stats =
                          analyzeFeedbackForColumn(feedbackData, column);
                      return FeedbackPieChart(
                          question: questions[index], feedbackStats: stats);
                    },
                  ),
                ),
                // Single legend displayed after the charts
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Map<String, int> analyzeFeedbackForColumn(
      List<Map<String, dynamic>> feedbackData, String columnName) {
    int goodCount = 0;
    int averageCount = 0;
    int badCount = 0;

    for (var feedback in feedbackData) {
      var value = feedback[columnName];

      if (value == 10) {
        goodCount++;
      } else if (value == 5) {
        averageCount++;
      } else if (value == 0) {
        badCount++;
      }
    }
    return {
      'Good': goodCount,
      'Average': averageCount,
      'Bad': badCount,
    };
  }
}
class FeedbackPieChart extends StatelessWidget {
  final String question;
  final Map<String, int> feedbackStats;
  FeedbackPieChart({required this.question, required this.feedbackStats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Center(
              child: PieChart(
                dataMap: {
                  'Good': feedbackStats['Good']!.toDouble(),
                  'Average': feedbackStats['Average']!.toDouble(),
                  'Bad': feedbackStats['Bad']!.toDouble(),
                },
                chartRadius: MediaQuery.of(context).size.width / 1.5,
                chartValuesOptions: ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
                chartLegendSpacing: Checkbox.width,
                legendOptions: LegendOptions(
                  showLegends: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
