import 'package:flutter/material.dart';
import '../viewmodel/sleepDiaryModel.dart';
import '../../components/theme.dart';

class SleepDiaryPage extends StatefulWidget {
  final SleepDiaryModel diaryModel;

  const SleepDiaryPage({super.key, required this.diaryModel});

  @override
  _SleepDiaryPageState createState() => _SleepDiaryPageState();
}

class _SleepDiaryPageState extends State<SleepDiaryPage> {
  TimeOfDay? bedtime;
  TimeOfDay? wakeTime;
  late TextEditingController reflectionController;
  late TextEditingController tagsController;

  @override
  void initState() {
    super.initState();
    reflectionController = TextEditingController();
    tagsController = TextEditingController();
  }

  @override
  void dispose() {
    reflectionController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  void _addEntry() {
    if (bedtime != null && wakeTime != null) {
      widget.diaryModel.addEntry(
        date: DateTime.now(),
        bedtime: bedtime!,
        wakeTime: wakeTime!,
        reflection: reflectionController.text,
        tags: tagsController.text.split(',').map((tag) => tag.trim()).toList(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Diary entry saved!")),
      );

      setState(() {
        reflectionController.clear();
        tagsController.clear();
        bedtime = null;
        wakeTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.diaryModel.entries;

    return Scaffold(
      appBar: AppTheme.buildAppBar('Sleep Diary'),
      body: BackgroundWrapper(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeButton('Select Bedtime', bedtime, (picked) => bedtime = picked),
                  const SizedBox(height: 12),
                  _buildTimeButton('Select Wake Time', wakeTime, (picked) => wakeTime = picked),
                  const SizedBox(height: 16),
                  _buildTextField(controller: reflectionController, hintText: 'Reflection'),
                  const SizedBox(height: 16),
                  _buildTextField(controller: tagsController, hintText: 'Tags (comma separated)'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addEntry,
                      style: AppTheme.elevatedButtonStyle,
                      child: const Text('Save Entry'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sleepTips');
                      },
                      style: AppTheme.elevatedButtonStyle,
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text('View Sleep Tips'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const Text(
                    'Past Entries',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final date = (entry['date'] as DateTime).toLocal().toString().split(' ')[0];
                      final tags = (entry['tags'] as List).join(", ");

                      return Card(
                        color: Colors.white.withOpacity(0.9),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: ListTile(
                          title: Text('Date: $date'),
                          subtitle: Text(
                            'Bed: ${entry['bedtime'].format(context)} | Wake: ${entry['wakeTime'].format(context)}\nReflection: ${entry['reflection']}',
                          ),
                          trailing: Text(tags),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay? time, Function(TimeOfDay) onSelected) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: AppTheme.elevatedButtonStyle,
        onPressed: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: time ?? TimeOfDay.now(),
          );
          if (picked != null) setState(() => onSelected(picked));
        },
        child: Text(
          time == null ? label : '$label: ${time.format(context)}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}
