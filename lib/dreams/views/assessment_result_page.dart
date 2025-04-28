import 'package:flutter/material.dart';
import '../../../Pages/screen_time.dart';
import '../models/goal.dart';
import '../repositories/settings_repository.dart';
import '../services/notification_scheduler.dart';
import 'sleep_data.dart';
import 'video_page.dart';
import '../../components/theme.dart';

class AssessmentResultPage extends StatelessWidget {
  final List<Goal> goals;
  const AssessmentResultPage({Key? key, required this.goals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Scaffold(
        appBar: AppTheme.buildAppBar('Your Sleep Goals'),
        body: const Center(
          child: Text('Great job! You’re within all of our recommended ranges.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppTheme.buildAppBar('Your Sleep Goals'),
      body: BackgroundWrapper(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (var goal in goals)
              Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: AppTheme.elevatedButtonStyle,
                onPressed: () async {
                  try {
                    final repo = SettingsRepository();
                    await repo.loadSettings();
                    final wakeTime = repo.settings.goodMorningTimeOfDay;

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
                        content: Text('Failed to schedule goal reminders: \$e'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Add goal reminders to your wake-up notification',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext ctx, String qId) {
    switch (qId) {
      case 'bedtime':
      case 'caffeine':
      case 'alcohol':
      case 'restful':
      case 'wake':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: AppTheme.elevatedButtonStyle,
            onPressed: () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => SleepData()),
            ),
            child: const Text('Open Sleep Diary / Tracker'),
          ),
        );

      case 'screen':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: AppTheme.elevatedButtonStyle,
            onPressed: () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const ScreenTimePage()),
            ),
            child: const Text('Track screen time'),
          ),
        );

      case 'stress':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: AppTheme.elevatedButtonStyle,
            onPressed: () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const VideoPage()),
            ),
            child: const Text('Guided meditation & yoga'),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
