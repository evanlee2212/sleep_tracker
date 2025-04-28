import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:sleep_app/components/theme.dart';
import 'package:sleep_app/components/theme_manager.dart';
import 'package:sleep_app/components/menu_button.dart';

import 'package:sleep_app/dreams/views/settings_page.dart';
import 'package:sleep_app/dreams/views/sleep_data.dart';
import 'package:sleep_app/dreams/views/resources_page.dart';
import 'package:sleep_app/dreams/views/notifications_page.dart';

import 'package:sleep_app/dreams/services/app_initializer.dart';
import 'package:sleep_app/dreams/services/startup_service.dart';
import 'package:sleep_app/dreams/services/notification_permissions.dart';
import 'package:sleep_app/dreams/services/welcome_message.dart';

import 'dreams/views/login_screen.dart';
import 'package:sleep_app/dreams/viewmodel/sleepDiaryModel.dart';

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
      title: 'Sleep App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: themeManager.themeMode,
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    NotificationHelper.requestPermissionsIfNeeded(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WelcomeService.showOnFirstLaunch(context);
    });

    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
  }


@override
Widget build(BuildContext context) {
  return BackgroundWrapper(
    child: Scaffold(
      extendBodyBehindAppBar: true, 
      backgroundColor: Colors.transparent,
      appBar: AppTheme.buildAppBar('', actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
          },
        )
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.translate(
                    offset: const Offset(0, -55),
                    child: CircleAvatar(
                      radius: 104,
                      backgroundColor: Colors.indigo,
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/logo.png'),
                        radius: 100,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                MenuButton(
                  text: 'Sleep Data',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepData())),
                ),
                const SizedBox(height: 20),
                MenuButton(
                  text: 'Resources',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourcesPage())),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
