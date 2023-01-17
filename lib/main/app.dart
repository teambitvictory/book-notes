import 'package:flutter/material.dart';
import 'package:reading_notes/notes/note_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Notes',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const NoteScreen(title: 'Book Notes'),
    );
  }
}
