import 'package:flutter/material.dart';

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
            const Text('Filler'),
          ],
        )
      ),
    );
  }
}

