import 'package:flutter/material.dart';
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
  final List<Note> noteList = [
    Note(
      key: 1.toString(),
      content: '''
      This is a body of text put into this special little note of mine
      ''',
      modifydate: DateTime.now(),
      createdate: DateTime.now(),
      systemtags: [],
      tags: [],
      syncnum: 1,
      version: 1,
      isDeleted: false,
    ),
    Note(
      key: 2.toString(),
      content: '''
      This other body of text is really interesting
      ''',
      modifydate: DateTime.now(),
      createdate: DateTime.now(),
      systemtags: [],
      tags: [],
      syncnum: 1,
      version: 1,
      isDeleted: false,
    )
  ];

  String _selectedSortBy = "Title";
  final List<String> _sortByOptions = ["Title" "Creation date" "Last modified"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes List'),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        actions: [
          DropdownButton(
            value: _selectedSortBy,
            items: _sortByOptions
                .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(
                      option.toString(),
                    )))
                .toList(),
            onChanged: (selectedOption) {
              setState(() {
                _selectedSortBy = selectedOption as String;
                switch (selectedOption.toLowerCase()) {
                  case "title":
                    {
                      noteList.sort(
                        (a, b) => a.title.compareTo(b.title),
                      );
                    }
                  case "creation date":
                    {
                      noteList.sort(
                        (a, b) => a.createdate.compareTo(b.createdate),
                      );
                    }
                  case "last modified":
                    {
                      noteList.sort(
                        (a, b) => a.modifydate.compareTo(b.modifydate),
                      );
                    }
                }
              });
            },
          ),
        ],
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
              subtitle: Text("${noteList[index].content.substring(0, 40)}..."),
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
}
