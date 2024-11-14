import 'package:flutter/material.dart';
import 'package:simplenote_flutter/api/data.dart';
import 'package:simplenote_flutter/note/note.dart';
import 'package:simplenote_flutter/pages/note/note_page.dart';

// final Data userData;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final List<Note> noteList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simplenote"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: noteList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(noteList[index].title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NotePage(currentNote: noteList[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Create a new note.",
        onPressed: () {
          var newNote = Note.newNote();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(currentNote: newNote),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
