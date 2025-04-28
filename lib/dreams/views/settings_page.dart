import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app/components/menu_button.dart';
import 'package:sleep_app/components/theme.dart';
import 'package:sleep_app/components/theme_manager.dart';
import 'package:sleep_app/dreams/contracts/settings_contract.dart';
import 'package:sleep_app/dreams/presenter/settings_presenter.dart';
import 'notifications_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> implements SettingsContractView {
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
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
    return BackgroundWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true, 
        backgroundColor: Colors.transparent,
        appBar: AppTheme.buildAppBar('Settings'),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  MenuButton(
                    text: 'Notifications',
                    onPressed: () => _presenter.onNotificationsPressed(),
                  ),
                  const SizedBox(height: 24),
                  MenuButton(
                    text: 'Switch Theme',
                    onPressed: () => _presenter.onAppThemePressed(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
