import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/notification.dart';
import '../components/menu_button.dart';
import 'package:sleep_app/dreams/contracts/settings_contract.dart';
import 'package:sleep_app/dreams/presenter/settings_presenter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> implements SettingsContractView{
  late final SettingsPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = SettingsPresenter(this);
  }

  @override
  void navigateToNotifications() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
  }

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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

            ],
          ),
        ),
      ),
    );
  }
}