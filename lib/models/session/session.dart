import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rhttp/rhttp.dart';
import 'package:simplenote_flutter/main.dart';
import '../note/note.dart';

class Session {
  HttpHeaders headers = HttpHeaders.map({
    HttpHeaderName.contentType: 'application/json',
    HttpHeaderName.acceptCharset: 'UTF-8',
  });
  final storage = FlutterSecureStorage();

  void updateCookie(HttpResponse response) {
    int headerIndex = response.headers.indexWhere(
      (s) => s.toString() == "set-cookie",
    );
    String? rawCookie = response.headers[headerIndex].toString();

    int index = rawCookie.indexOf(';');
    headers = HttpHeaders.map({
      HttpHeaderName.contentType: 'application/json',
      HttpHeaderName.acceptCharset: 'UTF-8',
      HttpHeaderName.setCookie:
          (index == -1) ? rawCookie : rawCookie.substring(0, index)
    });
  }

  final String email;

  Session({required this.email});

  void setAuthInfo(String email, String password) async {
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
  }

  Future<HttpTextResponse> sendAuthRequest(
      String email, String password) async {
    final body =
        utf8.encode("email=${email.trim()}&password=${password.trim()}");
    return httpClient.post(
      "https://simple+note.appspot.com/api/login",
      headers: const HttpHeaders.map({HttpHeaderName.contentType: 'text/pain'}),
      body: HttpBody.bytes(body),
    );
  }

  void syncSimplenote() async {
    var email = await storage.read(key: 'email');
    var password = await storage.read(key: 'password');
    var response = await sendAuthRequest(email.toString(), password.toString());
    updateCookie(response);
  }

  Future<Note> fetchNote(String notekey) async {
    final response = await httpClient.get(
      "https://simple+note.appspot.com/api2/data/$notekey?&email=$email",
    );

    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed to fetch note from API");
    }
  }

  Future<HttpResponse> createNote(Note note) {
    return httpClient.post(
      "https://simple+note.appspot.com/api2/data?&email=$email",
      headers: headers,
      body: HttpBody.json({
        'content': note.content,
        'tags': note.tags,
        'modifydate': note.modifydate,
        'createdate': note.createdate,
        'systemtags': note.systemtags,
      }),
    );
  }

  Future<HttpResponse> updateNote(Note note) {
    return httpClient.post(
      "https://simple+note.appspot.com/api2/data/${note.key}?&email=$email",
      headers: headers,
      body: HttpBody.json({
        'content': note.content,
        'tags': note.tags,
        'systemtags': note.systemtags,
        'version': note.version,
      }),
    );
  }

  Future<HttpResponse> setDeleted(Note note) {
    return httpClient.post(
      "https://simple+note.appspot.com/api2/data/${note.key}?&email=$email",
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

    var fetchedNote =
        Note.fromJson(jsonDecode(response.toString()) as Map<String, dynamic>);

    var finalNote = fetchNote(fetchedNote.key);

    return finalNote;
  }
}
