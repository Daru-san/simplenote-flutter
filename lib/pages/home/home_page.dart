import 'package:flutter/material.dart';
import 'package:simplenote_flutter/main.dart';
import 'package:simplenote_flutter/models/note/note.dart';
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
  List<Note> noteList = [];

  _getAllNotes() async {
    noteList = await noteDB.getAllNotes() as List<Note>;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAllNotes(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return Scaffold(
              appBar: AppBar(
                title: const Text('All notes'),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                actions: [],
              ),
              body: Center(
                child: ListView.builder(
                  itemCount: noteList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(noteList[index].content.substring(0, 10)),
                      isThreeLine: true,
                      selectedTileColor: Theme.of(context).hoverColor,
                      tileColor: Theme.of(context).cardColor,
                      subtitle: Text(
                          "${noteList[index].content.substring(0, 40)}..."),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotePage(),
                            settings: RouteSettings(arguments: noteList[index]),
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
                      builder: (context) => NotePage(),
                      settings: RouteSettings(arguments: newNote),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            );
        }
      },
    );
  }
}
