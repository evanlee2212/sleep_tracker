import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assessment_result.dart';
import '../repositories/assessment_repository.dart';

class PastAssessmentsPage extends StatelessWidget {
  const PastAssessmentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Assessments'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: StreamBuilder<List<AssessmentResult>>(
        stream: AssessmentRepository().watchPastAssessments(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('No past assessments found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final a = list[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timestamp
                      Text(
                        DateFormat.yMMMd().add_jm().format(a.timestamp),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),

                      //responses
                      ...a.responses.entries.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('• ${e.key}: ${e.value}'),
                      )),

                      const SizedBox(height: 8),
                      //goals
                      Text(
                        'Goals:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent),
                      ),
                      ...a.goals.entries.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('– ${e.value}'),
                      )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
