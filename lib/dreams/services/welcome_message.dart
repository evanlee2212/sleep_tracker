import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/assessment_page.dart';

class WelcomeService {
  //shows welcome dialog
  static Future<void> showOnFirstLaunch(BuildContext context) async {
    final prefs   = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('welcome_shown') ?? false;
    if (hasSeen) return;

    bool dontShowAgain = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hello and Welcome to Sweet Dreams!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'We are so glad you are here!\n\n'
                            'Feel free to explore the app on your own, '
                            'or use our assessment under the Resources tab to '
                            'see what tools will help you achieve your sleep goals!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black87),
                      ),
                      const SizedBox(height: 16),

                      //do not show again thing
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
                      const SizedBox(height: 8),

                      //assessment button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (dontShowAgain) {
                              prefs.setBool('welcome_shown', true);
                            }
                            Navigator.of(ctx).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AssessmentPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Take Assessment'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
