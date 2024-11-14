import 'dart:async';
import 'dart:convert';
import 'package:rhttp/rhttp.dart';
import 'package:simplenote_flutter/api/data.dart';

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

Future<Note> fetchNote(String notekey, Data userData) async {
  final response = await Rhttp.get(
    "https://simple+note.appspot.com/api2/data/$notekey?auth=${userData.authtoken}&email=${userData.email}",
  );

  if (response.statusCode == 200) {
    return Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to fetch note from API");
  }
}

Future<HttpResponse> createNote(Note note, Data userData) {
  return Rhttp.post(
    "https://simple+note.appspot.com/api2/data?auth=${userData.authtoken}&email=${userData.email}",
    headers: HttpHeaders.map({
      HttpHeaderName.contentType: 'application/json',
      HttpHeaderName.acceptCharset: 'UTF-8'
    }),
    body: HttpBody.json({
      'content': note.content,
      'tags': note.tags,
      'modifydate': note.modifydate,
      'createdate': note.createdate,
      'systemtags': note.systemtags,
    }),
  );
}

Future<HttpResponse> updateNote(Note note, Data userData) {
  return Rhttp.post(
    "https://simple+note.appspot.com/api2/data/${note.key}?auth=${userData.authtoken}&email=${userData.email}",
    headers: HttpHeaders.map({
      HttpHeaderName.contentType: 'application/json',
      HttpHeaderName.acceptCharset: 'UTF-8'
    }),
    body: HttpBody.json({
      'content': note.content,
      'tags': note.tags,
      'systemtags': note.systemtags,
      'version': note.version,
    }),
  );
}

Future<HttpResponse> setDeleted(Note note, Data userData) {
  return Rhttp.post(
    "https://simple+note.appspot.com/api2/data/${note.key}?auth=${userData.authtoken}&email=${userData.email}",
    headers: HttpHeaders.map({
      HttpHeaderName.contentType: 'application/json',
      HttpHeaderName.acceptCharset: 'UTF-8'
    }),
    body: HttpBody.json({
      'deleted': note.isDeleted,
    }),
  );
}

// Should be used to get and set a note when saving for the first time to obtain all data
// Notes would be saved and updated by this mechanism
Future<Note> newNote(Data userData) {
  var newNote = Note(
    key: "",
    content: "New note",
    title: "New note",
    modifydate: DateTime.now(),
    createdate: DateTime.now(),
    systemtags: [],
    tags: [],
    syncnum: 0,
    version: 0,
    isDeleted: false,
  );

  var response = createNote(newNote, userData);

  var fetchedNote =
      Note.fromJson(jsonDecode(response.toString()) as Map<String, dynamic>);

  var finalNote = fetchNote(fetchedNote.key, userData);

  return finalNote;
}

class Note {
  final String key;
  final String content;
  final String title;
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
    required this.title,
    required this.modifydate,
    required this.createdate,
    required this.systemtags,
    required this.tags,
    required this.syncnum,
    required this.version,
    required this.isDeleted,
  });

  factory Note.newNote() {
    return Note(
      key: "",
      content: "",
      title: "",
      modifydate: DateTime.now(),
      createdate: DateTime.now(),
      systemtags: [],
      tags: [],
      syncnum: 0,
      version: 0,
      isDeleted: false,
    );
  }

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
          title: content.substring(1, 10),
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
