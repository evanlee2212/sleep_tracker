import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app/Pages/sounds.dart';
import 'package:sleep_app/components/menu_button.dart';

class ResourcesPage extends StatefulWidget {
  ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resources'
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
                  text: 'Sounds',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SleepSoundApp()))
              ),

            ],
          ),
        ),
      ),
    );
  }
}