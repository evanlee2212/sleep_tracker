import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/sleep_data.dart';
import 'package:sleep_app/Pages/sounds.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sleep_app/Pages/notification.dart';
import 'package:sleep_app/components/menu_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
          toolbarHeight: 100,
        ),
      ),
      home: const MyHomePage(title: 'Sweet Dreams'),
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
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(
                    text: 'Sleep Data',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SleepData())),
                ),
                SizedBox(height: 10),
                MenuButton(
                    text: 'Resources',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SleepData())),
                ),
                SizedBox(height: 10),
                MenuButton(
                    text: 'Notifications',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SleepData())),
                ),
                SizedBox(height: 10),
              ],
            )
          )
      )
    );
  }
  }
