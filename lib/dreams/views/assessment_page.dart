import 'package:flutter/material.dart';
import '../models/assessment_question.dart';
import '../models/assessment_response.dart';
import '../models/goal.dart';
import '../presenter/assessment_presenter.dart';
import '../repositories/assessment_repository.dart';
import 'assessment_result_page.dart';
import 'past_assessments_page.dart';
import '../../components/theme.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage>
    implements AssessmentView {
  late final AssessmentPresenter _presenter;
  List<AssessmentQuestion> _questions = [];
  final Map<String, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    _presenter = AssessmentPresenter(
      view: this,
      repo: AssessmentRepository(),
    );
    _presenter.loadQuestions();
  }

  @override
  void onQuestionsLoaded(List<AssessmentQuestion> questions) {
    setState(() => _questions = questions);
  }

  @override
  void onAssessmentComplete(List<Goal> goals) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AssessmentResultPage(goals: goals),
      ),
    );
  }

  @override
  void onError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildQuestionField(AssessmentQuestion q) {
    switch (q.type) {
      case QuestionType.time:
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(q.prompt),
            subtitle: Text(
              _answers[q.id] != null
                  ? (_answers[q.id] as TimeOfDay).format(context)
                  : 'Select time',
            ),
            onTap: () async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (t != null) setState(() => _answers[q.id] = t);
            },
          ),
        );
      case QuestionType.integer:
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFormField(
              decoration: InputDecoration(labelText: q.prompt, border: InputBorder.none),
              keyboardType: TextInputType.number,
              onChanged: (v) => _answers[q.id] = int.tryParse(v) ?? 0,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _submit() {
    final responses = _questions.map((q) {
      final ans = _answers[q.id];
      return AssessmentResponse(questionId: q.id, answer: ans);
    }).toList();
    _presenter.submitResponses(responses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.buildAppBar('Sleep Assessment'),
      body: BackgroundWrapper(
        child: _questions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: _questions.map(_buildQuestionField).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: AppTheme.elevatedButtonStyle,
                        child: const Text('See Goals'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PastAssessmentsPage(),
                        ),
                      ),
                      child: const Text('View Previous Assessments'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
