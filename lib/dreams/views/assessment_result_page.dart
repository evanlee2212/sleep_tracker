import 'package:flutter/material.dart';
import '../models/goal.dart';
import 'sleep_data.dart';
import 'video_page.dart';

class AssessmentResultPage extends StatelessWidget {
  final List<Goal> goals;
  const AssessmentResultPage({Key? key, required this.goals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Your Sleep Goals')),
        body: Center(child: Text('Great job! You’re within all recommended ranges.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Your Sleep Goals')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: goals.map((g) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(g.suggestion, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  _buildActionButton(context, g.questionId),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButton(BuildContext ctx, String qId) {
    switch (qId) {
      case 'bedtime':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: Text('Try our sleep tracker here'),
        );
      case 'caffeine':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: Text('Track caffeine & sleep quality here'),
        );
      case 'alcohol':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: Text('Track alcohol & sleep quality here'),
        );
      case 'screen':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: Text('Track screen time here'),
        );
      case 'stress':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => const VideoPage()),
          ),
          child: Text('Try guided meditations or yoga here'),
        );
      case 'restful':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: Text('Explore and identify causes via journaling'),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
