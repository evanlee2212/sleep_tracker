import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/statistics.dart';
import 'sleepDiary.dart';
import '../dreams/viewmodel/sleepDiaryModel.dart';
import 'package:sleep_app/Pages/sleep_data.dart';
import 'package:sleep_app/Pages/sounds.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sleep_app/Pages/notification.dart';
import 'sleepTracker.dart';
import "../firebase_options.dart";
import 'login_screen.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    //home: MyHomePage(title: 'Flutter Demo Home Page', diaryModel: diaryModel),
    home: const LoginScreen(), 
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
            const SizedBox(height: 10),
            //sleep tracker implementation
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SleepTracker()));
              },
              child: Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.deepPurpleAccent,
                ),
                child: const Center(
                  child: Text(
                    'Sleep Tracker',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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

            SizedBox(height: 10),

            //Sounds Button
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsPage()));

              },
              child: Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.deepPurpleAccent,
                ),
                child: Center(child: Text('Statistics', style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ))),
              ),
            ),
            //implement sizedBox here

          SizedBox(height: 10),
              // Notifications Button (NEW)
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NotificationsPage())); // Navigate to the new page
                },
                child: Container(
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: Center(
                      child: Text('Notifications',
                          style: TextStyle(
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