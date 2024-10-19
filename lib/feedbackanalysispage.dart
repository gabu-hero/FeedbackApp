import 'package:feedback_app/appwriteprovider.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class FeedbackAnalysisPage extends StatefulWidget {
  final String courseCode;
  final String facultyName;

  FeedbackAnalysisPage({required this.facultyName, required this.courseCode});

  @override
  _FeedbackAnalysisPageState createState() => _FeedbackAnalysisPageState(
      fapsfacultyName: facultyName, fapscourseCode: courseCode);
}

class _FeedbackAnalysisPageState extends State<FeedbackAnalysisPage> {
  final String fapscourseCode;
  final String fapsfacultyName;
  _FeedbackAnalysisPageState(
      {required this.fapsfacultyName, required this.fapscourseCode});
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
  List<String> questionfrf = [
    'Coverage of the course curriculum',
    'Competence and commitment of faculty',
    'Communication of faculty (oral/written)',
    'Pace of the content covered by the faculty',
    'Relevance of the Content of curriculum',
    'CO1',
    'CO2',
    'CO3',
    'CO4',
    'CO5',
    'CO6',
    'LAB/INFRA',
    'Library'
  ];
  AppwriteService as = AppwriteService();

  @override
  void initState() {
    super.initState();
    loadFeedbackData();
  }

  void loadFeedbackData() async {
    List<Map<String, dynamic>> data =
        await as.getFeedbackForCourse(fapsfacultyName, fapscourseCode);
    setState(() {
      feedbackData = data;
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
      body: feedbackData.isNotEmpty
          ? GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0, // Make the items square
              ),
              itemCount: feedbackColumns.length,
              itemBuilder: (context, index) {
                String column = feedbackColumns[index];
                Map<String, int> stats =
                    analyzeFeedbackForColumn(feedbackData, column);
                return FeedbackPieChart(
                    question: questionfrf[index], feedbackStats: stats);
              },
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
            SizedBox(height: 16.0),
            PieChart(
              dataMap: {
                'Good': feedbackStats['Good']!.toDouble(),
                'Average': feedbackStats['Average']!.toDouble(),
                'Bad': feedbackStats['Bad']!.toDouble(),
              },
              chartRadius: MediaQuery.of(context).size.width / 3.5,
              chartValuesOptions: ChartValuesOptions(
                showChartValuesInPercentage: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
