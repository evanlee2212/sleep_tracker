import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/resourcesPage.dart';
import 'package:sleep_app/Pages/settingsPage.dart';
import '../components/menu_button.dart';
import 'package:sleep_app/Pages/sleep_data.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

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
      home: MyHomePage(title: 'Sweet Dreams'),
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
            color: Colors.white,
          )
        ]
      ),
      body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, -150),
                  child:CircleAvatar(
                    radius: 104,
                    backgroundColor: Colors.indigo,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      radius: 100,
                    ),
                  ),
                ),
                MenuButton(
                    text: 'Sleep Data',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SleepData())),
                ),
                SizedBox(height: 20),
                MenuButton(
                    text: 'Resources',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ResourcesPage())),
                ),
                SizedBox(height: 10),
              ],
            )
          )
      )
    );
  }
  }
