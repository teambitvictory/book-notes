import 'package:flutter/material.dart';
import 'package:reading_notes/notes/note_creation/recorder.dart';
import 'package:reading_notes/notes/note_list/note.dart';
import 'package:reading_notes/util/backend_connector.dart';

class NoteCreationScreen extends StatefulWidget {
  const NoteCreationScreen({super.key, required this.onAdd});
  final Function onAdd;
  @override
  State<NoteCreationScreen> createState() => _NoteCreationScreenState();
}

class _NoteCreationScreenState extends State<NoteCreationScreen> {
  var _parsedText = '';
  final _inputController = TextEditingController();

  void _setText(String text) {
    setState(() {
      _parsedText = text;
    });
    _inputController.text = text;
    _inputController.selection = TextSelection.fromPosition(
      TextPosition(offset: text.length),
    );
  }

  void _optimizeText() async {
    var currentText = _parsedText.trim();
    if (currentText.isEmpty) {
      return;
    }
    var optimizedText = await BackendConnector.makeGPTRequest(currentText);
    _setText(optimizedText);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Note'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _setText,
                  controller: _inputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Create a note',
                  ),
                  minLines: 2,
                  maxLines: 5,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _optimizeText,
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text("Optimize"),
                        ),
                        Recorder(onTextChange: (newText) {
                          _setText(newText);
                        }),
                        ElevatedButton(
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor: theme.colorScheme.primary,
                          //   textStyle: theme.textTheme.labelMedium!.copyWith(
                          //     color: Colors.white,
                          //   ),
                          // ),
                          onPressed: () {
                            widget.onAdd(content: _parsedText);
                            Navigator.pop(context);
                          },
                          child: const Text("Create"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
