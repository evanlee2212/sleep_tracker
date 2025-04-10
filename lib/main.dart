// main.dart
import 'package:flutter/material.dart';
import 'Pages/sleep_data.dart';
import 'Pages/sounds.dart';
import 'Pages/notifications_page.dart';
import 'Pages/sleepDiary.dart';
import 'Pages/sleepTracker.dart';
import 'dreams/viewmodel/sleepDiaryModel.dart';
import 'Pages/app_initializer.dart';
import 'Pages/startup_service.dart';
import 'Pages/settings_repository.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer().initialize();
  runApp(MyApp());
}

@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  if (receivedAction.channelKey == 'scheduled_channel') {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => NotificationsPage(
          settingsRepository: SettingsRepository(),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final diaryModel = SleepDiaryModel();
    final startupService = StartupService();

    return MaterialApp(
      title: 'Sleep App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: FutureBuilder(
        future: startupService.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  void _checkNotificationPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed && mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
          child: Text(text, style: const TextStyle(fontSize: 25, color: Colors.white)),
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
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SleepDiaryPage(diaryModel: widget.diaryModel)));
              }),
              buildButton('Sounds', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SleepSoundApp()));
              }),
              buildButton('Notifications', () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NotificationsPage(
                    settingsRepository: SettingsRepository(),
                  ),
                ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
