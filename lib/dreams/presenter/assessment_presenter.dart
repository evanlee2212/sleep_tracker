import 'package:flutter/material.dart';
import '../models/assessment_question.dart';
import '../models/assessment_response.dart';
import '../models/goal.dart';
import '../repositories/assessment_repository.dart';

//view interface for the assessment flow
abstract class AssessmentView {
  void onQuestionsLoaded(List<AssessmentQuestion> questions);
  void onAssessmentComplete(List<Goal> goals);
  void onError(String message);
}

//presenter loads questions, evaluates responses into goals, and save to firestore
class AssessmentPresenter {
  final AssessmentView view;
  final AssessmentRepository repo;

  //survey questions and thresholds
  final List<AssessmentQuestion> _questions = [
    AssessmentQuestion(
      id: 'bedtime',
      prompt: 'What time do you usually go to bed?',
      type: QuestionType.time,
      recommended: TimeOfDay(hour: 22, minute: 0),
    ),
    AssessmentQuestion(
      id: 'wake',
      prompt: 'What time do you wake up?',
      type: QuestionType.time,
      recommended: TimeOfDay(hour: 6, minute: 30),
    ),
    AssessmentQuestion(
      id: 'caffeine',
      prompt: 'How many mg of caffeine do you consume per day?',
      type: QuestionType.integer,
      recommended: 200,
    ),
    AssessmentQuestion(
      id: 'alcohol',
      prompt: 'How many alcoholic drinks do you have per week?',
      type: QuestionType.integer,
      recommended: 7,
    ),
    AssessmentQuestion(
      id: 'screen',
      prompt: 'Minutes of screen time in the hour before bed?',
      type: QuestionType.integer,
      recommended: 30,
    ),
    AssessmentQuestion(
      id: 'stress',
      prompt: 'Rate your stress level today (1–10)',
      type: QuestionType.integer,
      recommended: 5,
    ),
    AssessmentQuestion(
      id: 'restful',
      prompt: 'How restful was your sleep last night (1–10)?',
      type: QuestionType.integer,
      recommended: 6,
    ),
  ];

  AssessmentPresenter({
    required this.view,
    required this.repo,
  });

  //full question list to the view.
  void loadQuestions() {
    view.onQuestionsLoaded(_questions);
  }

  //evaluate responses, generate goals, save to Firestore, then callback
  Future<void> submitResponses(List<AssessmentResponse> responses) async {
    try {
      final goals = <Goal>[];
      final respMap = {for (var r in responses) r.questionId: r.answer};

      //bedtime
      final bed = respMap['bedtime'] as TimeOfDay?;
      final targetBed = _questions
          .firstWhere((q) => q.id == 'bedtime')
          .recommended as TimeOfDay;
      if (bed != null) {
        final diff = (bed.hour * 60 + bed.minute) -
            (targetBed.hour * 60 + targetBed.minute);
        if (diff.abs() > 30) {
          goals.add(Goal(
            questionId: 'bedtime',
            suggestion:
            'Aim to go to bed around ${_formatTimeOfDay(targetBed)}.',
          ));
        }
      }

      //wake time
      final wake = respMap['wake'] as TimeOfDay?;
      final targetWake = _questions
          .firstWhere((q) => q.id == 'wake')
          .recommended as TimeOfDay;
      if (wake != null) {
        final diff =
            (wake.hour * 60 + wake.minute) - (targetWake.hour * 60 + targetWake.minute);
        if (diff.abs() > 30) {
          goals.add(Goal(
            questionId: 'wake',
            suggestion:
            'Try waking up closer to ${_formatTimeOfDay(targetWake)} each morning.',
          ));
        }
      }

      //caffeine
      final caf = respMap['caffeine'] as int? ?? 0;
      final maxCaf = _questions
          .firstWhere((q) => q.id == 'caffeine')
          .recommended as int;
      if (caf > maxCaf) {
        goals.add(Goal(
          questionId: 'caffeine',
          suggestion:
          'Limit caffeine to ≤ $maxCaf mg/day and avoid it after mid-afternoon.',
        ));
      }

      //alcohol
      final alc = respMap['alcohol'] as int? ?? 0;
      final maxAlc = _questions
          .firstWhere((q) => q.id == 'alcohol')
          .recommended as int;
      if (alc > maxAlc) {
        goals.add(Goal(
          questionId: 'alcohol',
          suggestion: 'Consider drinking ≤ $maxAlc alcoholic beverages per week.',
        ));
      }

      //screen time
      final screen = respMap['screen'] as int? ?? 0;
      final maxScreen = _questions
          .firstWhere((q) => q.id == 'screen')
          .recommended as int;
      if (screen > maxScreen) {
        goals.add(Goal(
          questionId: 'screen',
          suggestion:
          'Aim for ≤ $maxScreen minutes of screens before bed (try blue-light filters).',
        ));
      }

      //stress levels
      final stress = respMap['stress'] as int? ?? 0;
      final maxStress = _questions
          .firstWhere((q) => q.id == 'stress')
          .recommended as int;
      if (stress > maxStress) {
        goals.add(Goal(
          questionId: 'stress',
          suggestion:
          'Your stress level is high—consider guided meditation or yoga before bed.',
        ));
      }

      //restful sleep
      final restful = respMap['restful'] as int? ?? 0;
      final minRest = _questions
          .firstWhere((q) => q.id == 'restful')
          .recommended as int;
      if (restful <= minRest) {
        goals.add(Goal(
          questionId: 'restful',
          suggestion:
          'Sleep quality seems low—try journaling or consult a sleep specialist.',
        ));
      }

      //save all responses + goals, then notify view
      await repo.saveAssessment(responses: responses, goals: goals);
      view.onAssessmentComplete(goals);
    } catch (e) {
      view.onError('Failed to save assessment: $e');
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
