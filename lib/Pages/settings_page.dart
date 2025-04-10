import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app/Pages/notification.dart';
import '../components/menu_button.dart';
import 'package:sleep_app/dreams/contracts/settings_contract.dart';
import 'package:sleep_app/dreams/presenter/settings_presenter.dart';
import '../components/theme_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> implements SettingsContractView{
  late final SettingsPresenter _presenter;
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    _presenter = SettingsPresenter(this);
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    isDark = themeManager.themeMode == ThemeMode.dark;
  }

  @override
  void navigateToNotifications() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
  }

  @override
  void swapAppTheme() {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    setState(() {
      isDark = !isDark;
      themeManager.toggleTheme(isDark);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Settings'
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
            children: [
              MenuButton(
                text: 'Notifications',
                onPressed: () => _presenter.onNotificationsPressed(),
              ),
              SizedBox(height: 10),
              MenuButton(
                text: 'Switch Theme',
                onPressed: () => _presenter.onAppThemePressed(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}