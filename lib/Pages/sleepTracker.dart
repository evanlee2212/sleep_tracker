//User Story:  As a user, I want to be able to record how long I sleep for on a given night
// Priority: Medium-High
// Estimate: 2 class days
// Acceptance Criteria: User through a click of a button starts sleep timer when the user goes to sleep. Button also clicked when the user wakes up to track sleep duration.
//For the sake of demonstration, initial prototype may have 10 seconds represent 1 hour to illustrate a full nights sleep on a smaller scale
import 'package:flutter/material.dart';

class SleepTracker extends StatefulWidget {
  const SleepTracker({super.key});

  @override
  State<SleepTracker> createState() => _SleepTrackerState();
}

class _SleepTrackerState extends State<SleepTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Tracker')),
      body: const Center(
        child: Text('Sleep tracker UI goes here.'),
      ),
    );
  }
}

//buttons needed for sleep tracker
//startTimer:
//endTimer

//widget showing time passing by on the corner of the app
//Still need to implement these for user story 1