import 'package:cloud_firestore/cloud_firestore.dart';

class AssessmentResult {
  final String id;
  final DateTime timestamp;
  final Map<String, String> responses;
  final Map<String, String> goals;

  AssessmentResult({
    required this.id,
    required this.timestamp,
    required this.responses,
    required this.goals,
  });

  factory AssessmentResult.fromMap(Map<String, dynamic> data, String id) {
    final ts = data['timestamp'];
    DateTime when;
    if (ts is Timestamp) {
      when = ts.toDate();
    } else {
      when = DateTime.now();
    }

    //response map
    final respList = data['responses'] as List<dynamic>? ?? [];
    final responses = <String, String>{};
    for (var item in respList) {
      if (item is Map<String, dynamic> && item.containsKey('q') && item.containsKey('a')) {
        responses[item['q'] as String] = item['a'] as String;
      }
    }
    //goals map
    final goalList = data['goals'] as List<dynamic>? ?? [];
    final goals = <String, String>{};
    for (var item in goalList) {
      if (item is Map<String, dynamic> && item.containsKey('q') && item.containsKey('s')) {
        goals[item['q'] as String] = item['s'] as String;
      }
    }

    return AssessmentResult(
      id: id,
      timestamp: when,
      responses: responses,
      goals: goals,
    );
  }
}
