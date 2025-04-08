import 'package:flutter/material.dart';
import 'sleepDiary.dart';
import '../dreams/viewmodel/sleepDiaryModel.dart';
import 'package:sleep_app/Pages/sleep_data.dart';
import 'package:sleep_app/Pages/sounds.dart';
import 'package:firebase_core/firebase_core.dart';
import 'sleepTracker.dart';
import 'package:sleep_app/Pages/notifications_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sleep_app/Pages/notification_scheduler.dart';
import 'package:sleep_app/Pages/settings_repository.dart';
import 'package:sleep_app/Pages/notification_settings.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initializationFuture = Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .then((_) => print('main: Firebase initialized')),
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
    ).then((_) => print('main: AwesomeNotifications initialized')),
  ]);

  runApp(MyApp(initializationFuture: initializationFuture));
}

Future<void> _scheduleNotificationsOnStartup() async {
  final repository = SettingsRepository();
  final scheduler = NotificationScheduler();
  await repository.loadSettings();
  final settings = repository.settings;

  await scheduler.cancelAllNotifications();
  await scheduler.scheduleSleepNotification(settings.windDownTimeOfDay);
  await scheduler.scheduleWakeUpNotification(settings.goodMorningTimeOfDay);
}

@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  if (receivedAction.channelKey == 'scheduled_channel') {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => NotificationsPage(settingsRepository: SettingsRepository()),
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final Future<void> initializationFuture;

  const MyApp({super.key, required this.initializationFuture});

  @override
  Widget build(BuildContext context) {
    final diaryModel = SleepDiaryModel();

    return MaterialApp(
      title: 'Sleep App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: FutureBuilder(
        future: initializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _scheduleNotificationsOnStartup();
            return MyHomePage(title: 'Flutter Demo Home Page', diaryModel: diaryModel);
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
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
  final SettingsRepository _settingsRepository = SettingsRepository();

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications to remind you to sleep and wake up.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Don't Allow"),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications().requestPermissionToSendNotifications();
                  Navigator.pop(context);
                },
                child: const Text('Allow'),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget buildButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 250,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.deepPurpleAccent,
        ),
        child: Center(
          child: Text(text,
              style: const TextStyle(fontSize: 25, color: Colors.white)),
        ),
      ),
    );
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton('Sleep Data', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SleepData()));
              }),
              buildButton('Sleep Tracker', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SleepTracker()));
              }),
              buildButton('Sleep Diary', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SleepDiaryPage(diaryModel: widget.diaryModel)));
              }),
              buildButton('Sounds', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SleepSoundApp()));
              }),
              buildButton('Notifications', () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NotificationsPage(settingsRepository: _settingsRepository),
                ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
