enum QuestionType { time, integer }

class AssessmentQuestion {
  final String id;
  final String prompt;
  final QuestionType type;
  final dynamic recommended;
  // e.g. for time: TimeOfDay target; for integer: int maxAllowed

  AssessmentQuestion({
    required this.id,
    required this.prompt,
    required this.type,
    required this.recommended,
  });
}
