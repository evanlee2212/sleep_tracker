//import current date
//field to enter sleep hours (enter float)
//sleep quality rating (int 1-5)
//interruption count (enter int)
//sleep details (enter text)
//enter dreams/nightmares (enter text)
//be able to make more dream/nightmare fields
//dream/nightmare radio buttons


import 'package:flutter/material.dart';

class NewSleepEntry extends StatefulWidget {
  const NewSleepEntry({super.key});

  @override
  State<NewSleepEntry> createState() => _NewSleepEntryState();
}

class _NewSleepEntryState extends State<NewSleepEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'New Sleep Entry'
        ),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,

      ),
      body: Center(
        child: InkWell(
          onTap: (){
            Navigator.pop(context, MaterialPageRoute(builder: (context) => NewSleepEntry()));
          },
        ),
      ),
    );
  }



}