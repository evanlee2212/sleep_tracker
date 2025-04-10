import 'package:flutter/material.dart';
import '/Pages/sounds.dart';
import '/dreams/views/video_page.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

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
        title: const Text('Resources'),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton('Sounds', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepSoundApp()));
            }),
            buildButton('Videos', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoPage()));
            }),
          ],
        ),
      ),
    );
  }
}
