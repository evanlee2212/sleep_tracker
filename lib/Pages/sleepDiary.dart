import 'package:flutter/material.dart';
import '../dreams/viewmodel/sleepDiaryModel.dart';

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
        SnackBar(content: Text("Diary entry saved!")),
      );

      // Clear input
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
      appBar: AppBar(title: Text("Sleep Diary")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                bedtime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                setState(() {});
              },
              child: Text(bedtime == null
                  ? "Select Bedtime"
                  : "Bedtime: ${bedtime!.format(context)}"),
            ),
            ElevatedButton(
              onPressed: () async {
                wakeTime = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                setState(() {});
              },
              child: Text(wakeTime == null
                  ? "Select Wake Time"
                  : "Wake Time: ${wakeTime!.format(context)}"),
            ),
            TextField(
              controller: reflectionController,
              decoration: InputDecoration(labelText: "Reflection"),
            ),
            TextField(
              controller: tagsController,
              decoration: InputDecoration(labelText: "Tags (comma separated)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addEntry,
              child: Text("Save Entry"),
            ),
            Divider(),
            Text(
              "Past Entries",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final date = (entry['date'] as DateTime)
                    .toLocal()
                    .toString()
                    .split(' ')[0];
                final tags = (entry['tags'] as List).join(", ");

                return Card(
                  child: ListTile(
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
    );
  }
}
