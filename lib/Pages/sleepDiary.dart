import 'package:flutter/material.dart';
import '../dreams/viewmodel/sleepDiaryModel.dart';
import '../components/theme.dart';

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

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[700]), 
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.diaryModel.entries;

    return Scaffold(
      appBar: AppTheme.buildAppBar("Sleep Diary"),
      body: BackgroundWrapper(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            bedtime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                            setState(() {});
                          },
                          style: AppTheme.elevatedButtonStyle,
                          child: Text(
                            bedtime == null ? "Select Bedtime" : "Bedtime: ${bedtime!.format(context)}",
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {
                            wakeTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                            setState(() {});
                          },
                          style: AppTheme.elevatedButtonStyle,
                          child: Text(
                            wakeTime == null ? "Select Wake Time" : "Wake Time: ${wakeTime!.format(context)}",
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(label: "Reflection", icon: Icons.notes, controller: reflectionController),
                        _buildTextField(label: "Tags (comma separated)", icon: Icons.label, controller: tagsController),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _addEntry,
                            style: AppTheme.elevatedButtonStyle,
                            child: const Text("Save Entry", style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "📘 Past Entries",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const Divider(thickness: 1.2),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final date = (entry['date'] as DateTime).toLocal().toString().split(' ')[0];
                    final tags = (entry['tags'] as List).join(", ");

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: const Icon(Icons.nightlight_round, color: Colors.deepPurpleAccent),
                        title: Text("Date: $date"),
                        subtitle: Text(
                          "Bed: ${entry['bedtime'].format(context)} | Wake: ${entry['wakeTime'].format(context)}\nReflection: ${entry['reflection']}",
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
    );
  }
}
