import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/assessment_response.dart';
import '../models/goal.dart';

class AssessmentRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String get _uid => _auth.currentUser!.uid;

  Future<void> saveAssessment({
    required List<AssessmentResponse> responses,
    required List<Goal> goals,
  }) {
    final doc = _firestore
        .collection('users')
        .doc(_uid)
        .collection('assessments')
        .doc(); // auto ID
    return doc.set({
      'timestamp': FieldValue.serverTimestamp(),
      'responses': responses
          .map((r) => {'q': r.questionId, 'a': r.answer.toString()})
          .toList(),
      'goals': goals.map((g) => {'q': g.questionId, 's': g.suggestion}).toList(),
    });
  }
}
