import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

// The idea here is to get the list of notes from the API along with the note index
// From there we either get each note from the array of notes or we only get the keys
// and then fetch each note individually until we get them all.
//
// I believe doing that will make things easier for me over parsing everything at once, in terms of updating
// and syncing notes.
//
// TODO: GET notes index along with keys
// Future<List<String>> fetchNotes() async {
//   final response = await http.get(Uri.parse(
//       "https://simple+note.appspot.com/api2/data/$notekey?auth=[auth6token]&email=[email]"));
// }
//
// class UserNotes maybe?
// Would contain an array of keys and the number of notes for a user

Future<Note> fetchNote(String notekey) async {
  //TODO: GET AUTHTOKEN
  final response = await http.get(Uri.parse(
      "https://simple+note.appspot.com/api2/data/$notekey?auth=[auth6token]&email=[email]"));

  if (response.statusCode == 200) {
    return Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to fetch note from API");
  }
}

Future<http.Response> createNote(Note note) {
  return http.post(
    Uri.parse(
        "https://simple+note.appspot.com/api2/data?auth=[auth6token]&email=[email]"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'content': note.content,
      'tags': note.tags,
      'modifydate': note.modifydate,
      'createdate': note.createdate,
      'systemtags': note.systemtags,
    }),
  );
}

Future<http.Response> updateNote(Note note) {
  return http.post(
    Uri.parse(
        "https://simple+note.appspot.com/api2/data/${note.key}?auth=[auth6token]&email=[email]"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'content': note.content,
      'tags': note.tags,
      'systemtags': note.systemtags,
      'version': note.version,
    }),
  );
}

Future<http.Response> modifyNote(Note note) {
  return http.post(
    Uri.parse(
        "https://simple+note.appspot.com/api2/data/${note.key}?auth=[auth6token]&email=[email]"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'deleted': note.isDeleted,
    }),
  );
}

class Note {
  final String key;
  final String content;
  final DateTime modifydate;
  final DateTime createdate;
  final int syncnum;
  final int version;
  final List<String> systemtags;
  final List<String> tags;
  final bool isDeleted;

  const Note({
    required this.key,
    required this.content,
    required this.modifydate,
    required this.createdate,
    required this.systemtags,
    required this.tags,
    required this.syncnum,
    required this.version,
    required this.isDeleted,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'key': String key,
        'content': String content,
        'modifydate': String modifydate,
        'createdate': String createdate,
        'syncnum': int syncnum,
        'version': int version,
        'systemtags': List<String> systemtags,
        'tags': List<String> tags,
        'isDeleted': bool isDeleted,
      } =>
        Note(
          key: key,
          content: content,
          modifydate: DateTime.parse(modifydate),
          createdate: DateTime.parse(createdate),
          systemtags: systemtags,
          tags: tags,
          syncnum: syncnum,
          version: version,
          isDeleted: isDeleted,
        ),
      _ => throw Exception("Failed to load note."),
    };
  }
}
