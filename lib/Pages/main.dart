import 'package:flutter/material.dart';
import 'sleepDiary.dart';
import '../dreams/viewmodel/sleepDiaryModel.dart';
import 'package:sleep_app/Pages/sleep_data.dart';
import 'package:sleep_app/Pages/sounds.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page',diaryModel: diaryModel,
        //home: SleepDiaryPage(diaryModel: diaryModel),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.diaryModel});

  final String title;
  final SleepDiaryModel diaryModel;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Sweet Dreams'
        ),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,

      ),
      body: SafeArea(
        child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
          //Sleep Data button
          InkWell(
            onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => SleepData()));

            },
            child: Container(
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.deepPurpleAccent,
              ),
              child: Center(child: Text('Sleep Data', style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ))),
            ),
          ),
          SizedBox(height: 10),

          //Sleep Diary button
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SleepDiaryPage(diaryModel: widget.diaryModel),
    ),
  );
},
            child: Container(
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.deepPurpleAccent,
              ),
              child: Center(child: Text('Sleep Diary', style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ))),
            ),
          ),
          SizedBox(height: 10),

          //Sounds Button
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SleepSoundApp()));

              },
              child: Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.deepPurpleAccent,
                ),
               child: Center(child: Text('Sounds', style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
               ))),
              ),
            ),
           ]
          ),
        ),
      ),
    );
  }
  }