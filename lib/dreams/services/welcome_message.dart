import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/assessment_page.dart';

class WelcomeService {
  //welcome dialog
  static Future<void> showOnFirstLaunch(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('welcome_shown') ?? false;
    if (hasSeen) return;

    bool dontShowAgain = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx2, setState) {
            return AlertDialog(
              title: const Text(
                'Hello and Welcome to Sweet Dreams!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'We are so glad you are here! Feel free to explore the app on your own, '
                        'or use our assessment under the Resources tab to see what tools will '
                        'help you achieve your sleep goals!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: dontShowAgain,
                        onChanged: (val) =>
                            setState(() => dontShowAgain = val ?? false),
                      ),
                      const Expanded(
                        child: Text('Do not show me this message again'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      if (dontShowAgain) {
                        prefs.setBool('welcome_shown', true);
                      }
                      Navigator.of(ctx2).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AssessmentPage(),
                        ),
                      );
                    },
                    child: const Text('Take Assessment'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
