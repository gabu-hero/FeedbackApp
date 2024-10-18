import 'package:feedback_app/appwriteprovider.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class FeedbackAnalysisPage extends StatefulWidget {
  final String courseCode;

  FeedbackAnalysisPage({required this.courseCode});

  @override
  _FeedbackAnalysisPageState createState() => _FeedbackAnalysisPageState();
}

class _FeedbackAnalysisPageState extends State<FeedbackAnalysisPage> {
  List<Map<String, dynamic>> feedbackData = [];
  List<String> feedbackColumns = ['frf1', 'frf2', 'frf3', 'co1_F', 'co2_F', 'co3_F'];

  AppwriteService as = AppwriteService();

  @override
  void initState() {
    super.initState();
    loadFeedbackData();
  }

  void loadFeedbackData() async {
    List<Map<String, dynamic>> data = await as.getFeedbackForCourse();
    setState(() {
      feedbackData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedback Analysis')),
      body: feedbackData.isNotEmpty
          ? ListView.builder(
              itemCount: feedbackColumns.length,
              itemBuilder: (context, index) {
                String column = feedbackColumns[index];
                Map<String, int> stats = analyzeFeedbackForColumn(feedbackData, column);
                return FeedbackPieChart(question: column, feedbackStats: stats);
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
  Map<String, int> analyzeFeedbackForColumn(List<Map<String, dynamic>> feedbackData, String columnName) {
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
    return Column(
      children: [
        Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        PieChart(
          dataMap: {
            'Good': feedbackStats['Good']!.toDouble(),
            'Average': feedbackStats['Average']!.toDouble(),
            'Bad': feedbackStats['Bad']!.toDouble(),
          },
          chartRadius: MediaQuery.of(context).size.width / 2.5,
          chartValuesOptions: ChartValuesOptions(
            showChartValuesInPercentage: true,
          ),
        ),
      ],
    );
  }

}