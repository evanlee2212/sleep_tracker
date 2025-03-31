import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/sleep_data.dart';
import 'package:sleep_app/Pages/sounds.dart';
import 'package:sleep_app/Pages/notifications_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sleep_app/Pages/notification_scheduler.dart';
import 'package:sleep_app/Pages/settings_repository.dart';
import 'package:sleep_app/Pages/notification_settings.dart';
import 'firebase_options.dart';

void main() async {
  print('main: Starting app initialization');
  WidgetsFlutterBinding.ensureInitialized();

  //Future completes when all initializations are done
  Future<void> initializationFuture = Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .then((value) => print('main: Firebase initialized')),
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Notification channel for scheduled notifications',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
      ],
    ).then((value) => print('main: AwesomeNotifications initialized')),
  ]);

  print('main: Initializations started');
  runApp(MyApp(initializationFuture: initializationFuture));
  print('main: App started');
}

//schedules notifications on app startup
Future<void> _scheduleNotificationsOnStartup() async {
  final repository = SettingsRepository();
  final scheduler = NotificationScheduler();
  await repository.loadSettings(); // Load settings here
  final settings = repository.settings;

  await scheduler.cancelAllNotifications();
  await scheduler.scheduleSleepNotification(settings.windDownTimeOfDay);
  await scheduler.scheduleWakeUpNotification(settings.goodMorningTimeOfDay);
}

@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  if (receivedAction.channelKey == 'scheduled_channel') {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => NotificationsPage(settingsRepository: SettingsRepository())),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final Future<void> initializationFuture;

  const MyApp({super.key, required this.initializationFuture});

  @override
  Widget build(BuildContext context) {
    print('MyApp: Building MyApp widget');
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: FutureBuilder(
        future: initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('MyApp: Initializations complete, building UI');
            //schedule notifications after initializations are complete
            _scheduleNotificationsOnStartup();
            return const MyHomePage(title: 'Flutter Demo Home Page');
          } else {
            print('MyApp: Initializations in progress, showing loading indicator');
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
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
  final SettingsRepository _settingsRepository = SettingsRepository(); // Create an instance here
  @override
  void initState() {
    super.initState();

    //request notification permissions
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text(
                'Our app would like to send you notifications to remind you to sleep and wake up.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Don\'t Allow'),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: const Text('Allow'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sweet Dreams'),
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
              // Sleep Data button
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SleepData()));
                },
                child: Container(
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: const Center(
                      child: Text('Sleep Data',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ))),
                ),
              ),
              const SizedBox(height: 10),
              // Sounds Button
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SleepSoundApp()));
                },
                child: Container(
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: const Center(
                      child: Text('Sounds',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ))),
                ),
              ),
              const SizedBox(height: 10),
              // Notifications Button (NEW)
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsPage(settingsRepository: _settingsRepository))); // Pass the instance here
                },
                child: Container(
                  height: 60,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.deepPurpleAccent,
                  ),
                  child: const Center(
                      child: Text('Notifications',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}