import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';
import 'package:simplenote_flutter/api/data.dart';
import 'package:simplenote_flutter/note/note.dart' as notes;
import 'package:simplenote_flutter/note/note.dart';
import './note_entries.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key, required this.currentNote});
  final Note currentNote;

  @override
  State<NotePage> createState() {
    return _NotePageState();
  }
}

/*
* Here I have two options:
* Those being whether to fetch the notes as this page opens
* or to store the notes in the database immedietly after opening the app
* in that situation, I only have to open the notes and send them from the
* home page using a method, and deal with updating notes in this class
*/

class _NotePageState extends State<NotePage> {
  String noteTitle = "";
  String noteContent = "";
  List<String> noteTags = [];

  final Note currentNote;
  const _NotePageState({required this.currentNote});

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _contentTextController = TextEditingController();

  void titleTextChanged() {
    setState(() {
      noteTitle = _titleTextController.text.trim();
    });
  }

  void contentTextChanged() {
    setState(() {
      noteContent = _contentTextController.text.trim();
    });
  }

  @override
  void initState() {
    super.initState();
    _titleTextController.addListener(titleTextChanged);
    _contentTextController.addListener(contentTextChanged);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  void getNote() async {
    noteContent = this.currentNote.content.toString();
    noteTags = this.currentNote.tags;
  }

  void createNote() {
    final Data userData = Data(email: "", authtoken: "");
    Note note = Note(
      key: "",
      content: noteContent,
      modifydate: DateTime.now(),
      createdate: DateTime.now(),
      systemtags: noteTags,
      tags: noteTags,
      syncnum: 1,
      version: 1,
      isDeleted: false,
    );

    try {
      notes.createNote(note, userData);
    } catch (e) {
      printToConsole("Error saving note");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: NoteTitleEntry(_titleTextController),
      ),
      body: NoteEntry(_contentTextController),
      floatingActionButton: FloatingActionButton(
        tooltip: "Save note",
        onPressed: () {},
        child: const Icon(Icons.save),
      ),
    );
  }
}
