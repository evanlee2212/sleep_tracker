import 'package:flutter/material.dart';
import 'package:sleep_app/dreams/viewmodel/SoundsModel.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sounds',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MySoundPage(title: 'Sounds'),
    );
  }
}

class MySoundPage extends StatefulWidget {
  const MySoundPage({super.key, required this.title});

  final String title;

  @override
  State<MySoundPage> createState() => _MySoundPageState();
}

class _MySoundPageState extends State<MySoundPage> {
  /// Todo: Add soundbar?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SoundWidget(filePath: "Sound/file/path", name: "Sound name"),
            const Divider(height: 10, thickness: 1, indent: 0, endIndent: 0, color: Colors.white),
            SoundWidget(filePath: "Sound/file/path", name: "Sound name 2")
          ],
        )
      ),
    );
  }
}

class SoundWidget extends StatefulWidget {
  final String name;
  final String filePath;

  const SoundWidget({Key? key, required this.filePath, required this.name}) : super(key: key);

  @override
  _SoundWidgetState createState() => _SoundWidgetState();

}

class _SoundWidgetState extends State<SoundWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource(widget.filePath));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: _playSound,
     child: Container(
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(
         color: Colors.deepPurple,
         borderRadius: BorderRadius.circular(10),
       ),
       child: Center(
         child: Text(
           widget.name,
           style: const TextStyle(color: Colors.black, fontSize: 16),
         ),
       )
     ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}