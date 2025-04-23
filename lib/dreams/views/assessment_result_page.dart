import 'package:flutter/material.dart';
import '../models/goal.dart';
import 'sleep_data.dart';
import 'video_page.dart';
import '../../../Pages/screen_time.dart';

class AssessmentResultPage extends StatelessWidget {
  final List<Goal> goals;
  const AssessmentResultPage({Key? key, required this.goals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Sleep Goals'),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: const Center(
          child: Text('Great job! You’re within all of our recommended ranges.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Sleep Goals'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: goals.length,
        itemBuilder: (ctx, i) {
          final goal = goals[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.suggestion, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  _buildActionButton(context, goal.questionId),
                ],
              ),
            ),
          );
        },
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
          child: const Text('Try our sleep tracker  or sleep cycle calculator here'),
        );

      case 'caffeine':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: const Text('Track caffeine consumption & sleep quality here'),
        );

      case 'alcohol':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: const Text('Track alcohol consumption & sleep quality here'),
        );

      case 'screen':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => const ScreenTimePage()),
          ),
          child: const Text('Track screen time here'),
        );

      case 'stress':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => const VideoPage()),
          ),
          child: const Text('Try guided meditation or yoga here'),
        );

      case 'restful':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: const Text('Explore causes via journaling'),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

