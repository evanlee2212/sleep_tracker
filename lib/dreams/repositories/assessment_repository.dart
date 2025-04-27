import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/assessment_response.dart';
import '../models/goal.dart';
import '../models/assessment_result.dart';

class AssessmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth         = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  //sve to firebase
  Future<void> saveAssessment({
    required List<AssessmentResponse> responses,
    required List<Goal> goals,
  }) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('assessments')
        .add({
      'timestamp': FieldValue.serverTimestamp(),
      'responses': responses
          .map((r) => {'q': r.questionId, 'a': r.answer.toString()})
          .toList(),
      'goals': goals.map((g) => {'q': g.questionId, 's': g.suggestion}).toList(),
    });
  }

  Stream<List<AssessmentResult>> watchPastAssessments() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(<AssessmentResult>[]);
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('assessments')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snap) => snap.docs.map((doc) {
        return AssessmentResult.fromMap(doc.data(), doc.id);
      }).toList());
    });
  }
}
