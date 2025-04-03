import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/sleepDiary.dart';
import 'package:sleep_app/Pages/sleepRank.dart';
import 'package:sleep_app/components/menu_button.dart';
import 'package:sleep_app/Pages/sleepTracker.dart';
import '../dreams/viewmodel/sleepDiaryModel.dart';

class SleepData extends StatefulWidget {
   SleepData({super.key});

  @override
  State<SleepData> createState() => _SleepDataState();
}

class _SleepDataState extends State<SleepData> {
  final SleepDiaryModel diaryModel = SleepDiaryModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sleep Data'
        ),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,

      ),
        body: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuButton(
                      text: 'New Sleep Entry',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SleepDiaryPage(diaryModel: diaryModel))),
                    ),
                    SizedBox(height: 10),
                    MenuButton(
                      text: 'Sleep Tracker',
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SleepTracker())),
                    ),
                    SizedBox(height: 10),
                    MenuButton(
                        text: 'Sleep Ranking',
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SleepRank())),
                    ),
                  ],
                )
            )
        )
    );
  }
}