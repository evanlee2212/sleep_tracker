import 'package:flutter/material.dart';
import 'package:sleep_app/dreams/viewmodel/sleepDiaryModel.dart';
import 'dreams/views/sleep_data.dart';
import 'dreams/views/notifications_page.dart';
import 'dreams/views/resources_page.dart';
import 'dreams/services/app_initializer.dart';
import 'dreams/services/startup_service.dart';
import 'dreams/services/notification_permissions.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app/dreams/views/settings_page.dart';
import 'components/menu_button.dart';
import 'package:sleep_app/components/theme_manager.dart';
import 'Pages/login_screen.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer().initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  if (receivedAction.channelKey == 'scheduled_channel') {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const NotificationsPage(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final startupService = StartupService();

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeManager.themeMode,
      title: 'Sleep App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: FutureBuilder(
        future: startupService.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const LoginScreen();


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
  const MyHomePage({super.key, required this.title, required SleepDiaryModel diaryModel});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    NotificationHelper.requestPermissionsIfNeeded(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
          )
        ],
        title: const Text('Sweet Dreams'),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
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
          ),
        ),
      ),
    );
  }
}