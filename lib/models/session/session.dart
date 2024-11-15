import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../note/note.dart';

class Session {
  Map<String, String> headers = {
    'content-type': 'application/json',
    'charset': 'UTF-8'
  };

  final storage = FlutterSecureStorage();

  final client = http.Client();
  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];

    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  final String email;

  Session({required this.email});

  void setAuthInfo(String email, String password) async {
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
  }

  Future<http.Response> sendAuthRequest(String email, String password) async {
    final body = utf8.encode(
      "email=${email.trim()}&password=${password.trim()}",
    );
    var response = await client.post(
      Uri.parse("https://simple+note.appspot.com/api/login"),
      headers: headers,
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception("Error obtaining API authentication");
    }
    return response;
  }

  Future<Session> syncSimplenote() async {
    var email = await storage.read(key: 'email');
    var password = await storage.read(key: 'password');
    var response = await sendAuthRequest(email.toString(), password.toString());
    updateCookie(response);
    return Session(email: email.toString());
  }

  Future<Note> fetchNote(String notekey) async {
    final response = await client.get(
      Uri.parse(
        "https://simple+note.appspot.com/api2/data/$notekey?&email=$email",
      ),
    );

    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to fetch note from API");
    }
  }

  Future<http.Response> createNote(Note note) {
    return client.post(
      Uri.parse("https://simple+note.appspot.com/api2/data?&email=$email"),
      headers: headers,
      body: json.encode({
        'content': note.content,
        'tags': note.tags,
        'modifydate': Duration(
          milliseconds: note.modifydate.millisecondsSinceEpoch,
        ).inSeconds.toString(),
        'createdate': Duration(
          milliseconds: note.createdate.millisecondsSinceEpoch,
        ).inSeconds.toString(),
        'systemtags': note.systemtags,
      }),
    );
  }

  Future<http.Response> updateNote(Note note) {
    return client.post(
      Uri.parse(
        "https://simple+note.appspot.com/api2/data/${note.key}?&email=$email",
      ),
      headers: headers,
      body: json.encode({
        'content': note.content,
        'tags': note.tags,
        'systemtags': note.systemtags,
        'version': note.version,
      }),
    );
  }

  Future<http.Response> setDeleted(Note note) {
    return client.post(
      Uri.parse(
        "https://simple+note.appspot.com/api2/data/${note.key}?&email=$email",
      ),
      headers: headers,
      body: json.encode({
        'deleted': note.isDeleted,
      }),
    );
  }

// Should be used to get and set a note when saving for the first time to obtain all data
// Notes would be saved and updated by this mechanism
  Future<Note> newNote() {
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

    var response = createNote(newNote);

    var fetchedNote = Note.fromJson(
      jsonDecode(response.toString()) as Map<String, dynamic>,
    );

    var finalNote = fetchNote(fetchedNote.key);

    return finalNote;
  }
}
