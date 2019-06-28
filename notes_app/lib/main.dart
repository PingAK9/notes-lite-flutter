import 'package:flutter/material.dart';
import 'package:flutter_notes_app/notes/notes_list.dart';
import 'package:flutter_notes_app/notes/edit_labels.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue,
        accentColor: Colors.lightGreen,
      ),
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (BuildContext build) => new NotesList(-1),
        '/editLabels': (BuildContext build) => new EditLabels(),
      },
    );
  }
}
