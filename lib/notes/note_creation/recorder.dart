import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reading_notes/util/backend_connector.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

final record = Record();

class Recorder extends StatefulWidget {
  const Recorder({super.key, required this.onTextChange});
  final Function onTextChange;

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  bool _isRecording = false;
  String response = '';

  Future<bool> _checkPermissions() async {
    return await record.hasPermission();
  }

  void _startRecording() async {
    if (!await _checkPermissions()) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Missing permission"),
      // ));
      return;
    }
    var path = (await getTemporaryDirectory()).path;
    await record.start(
      path: '$path/temp.m4a',
    );
    setState(() {
      _isRecording = true;
    });
  }

  void _stopRecording() async {
    setState(() {
      _isRecording = false;
    });
    await record.stop();
    var path = (await getTemporaryDirectory()).path;
    var text = await BackendConnector.makeWhisperRequest(path);
    widget.onTextChange(text);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_isRecording) {
          _stopRecording();
        } else {
          _startRecording();
        }
      },
      child: Icon(_isRecording ? Icons.stop : Icons.mic),
    );
  }
}
