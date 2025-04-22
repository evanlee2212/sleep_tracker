import 'package:flutter/material.dart';
import '../models/goal.dart';

class AssessmentResultPage extends StatelessWidget {
  final List<Goal> goals;
  const AssessmentResultPage({Key? key, required this.goals})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Sleep Goals')),
      body: goals.isEmpty
          ? Center(child: Text('Great job! You’re within all recommended ranges.'))
          : ListView.builder(
        itemCount: goals.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: Icon(Icons.check_circle_outline),
          title: Text(goals[i].suggestion),
        ),
      ),
    );
  }
}
