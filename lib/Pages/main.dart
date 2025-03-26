import 'package:flutter/material.dart';
import 'sleepDiary.dart';
import '../dreams/viewmodel/sleepDiaryModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SleepDiaryModel diaryModel = SleepDiaryModel();

  MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep App',
      debugShowCheckedModeBanner: false,
      home: SleepDiaryPage(diaryModel: diaryModel),
    );
  }
}
