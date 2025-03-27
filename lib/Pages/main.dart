import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/sleep_data.dart';
import 'package:sleep_app/Pages/sounds.dart';
import 'package:sleep_app/Pages/notification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
        child: Container(
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
