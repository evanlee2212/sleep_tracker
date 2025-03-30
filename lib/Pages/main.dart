import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/sleep_data.dart';
import 'package:sleep_app/Pages/sounds.dart';
import 'package:sleep_app/Pages/notification.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Required for async calls before runApp
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Notification channel for scheduled notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
      ),
    ],
  );
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

  void initState() {
    super.initState(); // Call the superclass's initState() first

    // Request notification permissions
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text(
                'Our app would like to send you notifications to remind you to sleep and wake up.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Don\'t Allow'),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: Text('Allow'),
              ),
            ],
          ),
        );
      }
    });
    _scheduleSleepNotification();
    _scheduleWakeUpNotification();
  }

  void _scheduleSleepNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1, // Unique ID for the notification
        channelKey: 'scheduled_channel',
        title: 'Time to Sleep!',
        body: 'It\'s time to wind down and get ready for bed.',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 22, // 10 PM
        minute: 0,
        second: 0,
        repeats: true, // Repeat every day
      ),
    );
  }
  void _scheduleWakeUpNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2, // Unique ID for the notification
        channelKey: 'scheduled_channel',
        title: 'Good Morning!',
        body: 'It\'s time to wake up and start your day.',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 7, // 7 AM
        minute: 0,
        second: 0,
        repeats: true, // Repeat every day
      ),
    );
  }

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
