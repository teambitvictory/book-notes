import 'package:flutter/material.dart';
import 'package:reading_notes/notes/note_creation/note_creation_screen.dart';
import 'package:reading_notes/notes/note_list/note.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key, required this.title});

  final String title;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final List<Note> _notes = [];

  void _addNote({title, required content, tags = const <String>[]}) {
    var note = Note(
      title: title,
      content: content,
      tags: tags,
    );
    setState(() {
      _notes.add(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _notes.isEmpty
              ? const Center(child: Text('No notes yet.'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: _notes,
                ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
        currentIndex: 1,
        onTap: (int newIndex) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NoteCreationScreen(onAdd: _addNote),
            ),
          );
        },
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
