import 'package:flutter/material.dart';
import '../models/assessment_question.dart';
import '../models/assessment_response.dart';
import '../models/goal.dart';
import '../presenter/assessment_presenter.dart';
import '../repositories/assessment_repository.dart';
import 'assessment_result_page.dart';
import 'past_assessments_page.dart';


class AssessmentPage extends StatefulWidget {
  const AssessmentPage({Key? key}) : super(key: key);

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
        return ListTile(
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
        );
      case QuestionType.integer:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            decoration: InputDecoration(labelText: q.prompt),
            keyboardType: TextInputType.number,
            onChanged: (v) => _answers[q.id] = int.tryParse(v) ?? 0,
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
      appBar: AppBar(
        title: const Text('Sleep Assessment'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _questions.isEmpty
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
            ElevatedButton(
              onPressed: _submit,
              child: const Text('See Goals'),
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
    );
  }
}
