import 'package:flutter/material.dart';
import 'package:sleep_app/dreams/views/screen_time_view.dart';
import '../models/goal.dart';
import '../repositories/settings_repository.dart';
import '../services/notification_scheduler.dart';
import 'sleep_data.dart';
import 'video_page.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (var goal in goals)
            Card(
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
            ),

          const SizedBox(height: 24),

          //button to add goal reminders
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () async {
              try {
                //load the user’s saved wake-up time
                final repo = SettingsRepository();
                await repo.loadSettings();
                final wakeTime = repo.settings.goodMorningTimeOfDay;

                //reminder from each goal
                final bodyLines = goals.map((g) {
                  switch (g.questionId) {
                    case 'caffeine':
                      return 'Remember to limit caffeine intake to improve your sleep tonight!';
                    case 'alcohol':
                      return 'Remember to limit alcohol consumption to improve your sleep tonight!';
                    case 'screen':
                      return 'Remember to limit screen time before bed.';
                    case 'stress':
                      return 'Try guided meditation or yoga before bed to reduce stress.';
                    case 'restful':
                      return 'Explore causes of poor sleep by journaling today.';
                    case 'bedtime':
                      return 'Aim to go to bed around the same time each night.';
                    case 'wake':
                      return 'Try waking up at a consistent time each morning.';
                    default:
                      return g.suggestion;
                  }
                }).join('\n');

                //schedule the wake-up notification with our custom goals!!
                await NotificationScheduler()
                    .scheduleWakeUpNotification(wakeTime, customBody: bodyLines);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Goal reminders added to your wake-up notification!',
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to schedule goal reminders: $e'),
                  ),
                );
              }
            },
            child: const Text(
              'Add goal reminders to your wake-up notification',
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
          child: const Text('Try our sleep tracker or sleep cycle calculator here'),
        );

      case 'caffeine':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: const Text('Track caffeine consumption & sleep quality using the Sleep Diary'),
        );

      case 'alcohol':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: const Text('Track alcohol consumption & sleep quality using the Sleep Diary'),
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

      case 'wake':
        return ElevatedButton(
          onPressed: () => Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => SleepData()),
          ),
          child: const Text('Try our sleep tracker or sleep cycle calculator here'),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
