import 'package:flutter/material.dart';
import '../models/assessment_question.dart';
import '../models/assessment_response.dart';
import '../models/goal.dart';
import '../repositories/assessment_repository.dart';

abstract class AssessmentView {
  void onQuestionsLoaded(List<AssessmentQuestion> questions);
  void onAssessmentComplete(List<Goal> goals);
  void onError(String message);
}

class AssessmentPresenter {
  final AssessmentView view;
  final AssessmentRepository repo;

  final _questions = <AssessmentQuestion>[
    AssessmentQuestion(
      id: 'bedtime',
      prompt: 'What time do you usually go to bed?',
      type: QuestionType.time,
      recommended: TimeOfDay(hour:22, minute:0),
    ),
    AssessmentQuestion(
      id: 'wake',
      prompt: 'What time do you wake up?',
      type: QuestionType.time,
      recommended: TimeOfDay(hour:6, minute:30),
    ),
    AssessmentQuestion(
      id: 'caffeine',
      prompt: 'How many mg of caffeine do you consume per day?',
      type: QuestionType.integer,
      recommended: 200,
    ),
    AssessmentQuestion(
      id: 'alcohol',
      prompt: 'How many alcoholic drinks per week?',
      type: QuestionType.integer,
      recommended: 7,
    ),
    AssessmentQuestion(
      id: 'screen',
      prompt: 'Minutes of screen time in the hour before bed?',
      type: QuestionType.integer,
      recommended: 30,
    ),
  ];

  AssessmentPresenter({required this.view, required this.repo});

  void loadQuestions() {
    view.onQuestionsLoaded(_questions);
  }

  void submitResponses(List<AssessmentResponse> responses) async {
    try {
      final goals = <Goal>[];

      final respMap = { for (var r in responses) r.questionId : r.answer };

      TimeOfDay bed = respMap['bedtime'];
      TimeOfDay targetBed = _questions.firstWhere((q)=>q.id=='bedtime').recommended;
      if ((bed.hour*60+bed.minute - (targetBed.hour*60+targetBed.minute)).abs() > 30) {
        goals.add(Goal(
          questionId: 'bedtime',
          suggestion: 'Aim to go to bed around ${targetBed.format(GlobalKey<NavigatorState>().currentContext!)}',
        ));
      }

      int caf = respMap['caffeine'];
      int maxCaf = _questions.firstWhere((q)=>q.id=='caffeine').recommended;
      if (caf > maxCaf) {
        goals.add(Goal(
          questionId: 'caffeine',
          suggestion: 'Try limiting caffeine to no more than $maxCaf mg per day, and avoid it after 2 PM.',
        ));
      }

      int alc = respMap['alcohol'];
      int maxAlc = _questions.firstWhere((q)=>q.id=='alcohol').recommended;
      if (alc > maxAlc) {
        goals.add(Goal(
          questionId: 'alcohol',
          suggestion: 'Consider reducing alcohol to under $maxAlc drinks per week.',
        ));
      }

      int scr = respMap['screen'];
      int maxScr = _questions.firstWhere((q)=>q.id=='screen').recommended;
      if (scr > maxScr) {
        goals.add(Goal(
          questionId: 'screen',
          suggestion: 'Aim for under $maxScr minutes of screens before bed, or switch to blue‑light filters.',
        ));
      }


      await repo.saveAssessment(responses: responses, goals: goals);
      view.onAssessmentComplete(goals);
    } catch (e) {
      view.onError('Failed to save assessment: $e');
    }
  }
}
