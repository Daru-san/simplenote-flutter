import 'package:flutter/material.dart';
import 'package:simplenote_flutter/main.dart';
import 'package:simplenote_flutter/models/note/note.dart';
import 'package:simplenote_flutter/views/text_editing_view.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

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
  Note currentNote = Note.newNote();

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
    noteContent = currentNote.content.toString();
    noteTags = currentNote.tags;
  }

  void setNote(Note note) {
    currentNote = note;
    getNote();
  }

  void fetchNote() async {
    if (currentNote.key != "") {
      var note = currentSession.fetchNote(currentNote.key);
      currentNote = await note;
    } else {}
  }

  void saveNote() {
    if (currentNote.key != "") {
      updateNote();
    } else {
      saveNewNote();
    }
  }

  void saveNewNote() {
    currentSession.createNote(currentNote);
  }

  void updateNote() {
    currentSession.updateNote(currentNote);
  }

  @override
  Widget build(BuildContext context) {
    final note = ModalRoute.of(context)!.settings.arguments as Note;
    setNote(note);
    return Scaffold(
      appBar: AppBar(
        title: NoteTitleEntry(
          textFieldController: _titleTextController,
      bottomSheet: BottomAppBar(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: noteTags.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(noteTags[index]),
              tileColor: Theme.of(context).primaryColor,
            );
          },
        ),
      ),
      body: TextEditingView(
        textFieldController: _contentTextController,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Save note",
        onPressed: () => currentNote.saveLocalNote(),
        child: const Icon(Icons.save),
      ),
    );
  }
}
