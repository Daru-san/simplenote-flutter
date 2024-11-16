import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplenote_flutter/models/note/note.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.make();

  factory DatabaseHelper() => _instance;

  static var _db;

  Future<Database> get db async {
    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'notes.db');
    var noteDB = openDatabase(path, version: 1, onCreate: _onCreate);
    return noteDB;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes_table (
        id INTEGER PRIMARY KEY,
        key INTEGER,
        content TEXT,
        creation_date INTEGER,
        modified_date INTEGER
      );
    ''');
  }

  Future<int> insertNote(Note note) async {
    var dbClient = await db;
    int count = await dbClient.insert('notes_table', note.toMap());
    return count;
  }

  Future<List> getAllNotes() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('''
      SELECT * FROM notes_table ORDER BY id ASC
      ''');
    return result.toList();
  }

  Future<bool> checkNote(int id) async {
    var dbClient = await db;
    var result = await dbClient.query(
      'notes_table',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.first.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> getCount() async {
    var dbClient = await db;
    int count = Sqflite.firstIntValue(await dbClient.rawQuery('''
      SELECT COUNT(*) FROM notes_table
      '''))!;
    return count;
  }

  Future<Note> getNote(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery('''
      SELECT * FROM notes_table WHERE id == $id
      ''');
    return Note.fromMap(result.first);
  }

  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    var result = await dbClient.delete(
      'notes_table',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> updateNote(Note note) async {
    var dbClient = await db;
    var result = await dbClient.update('notes_table', note.toMap());
    return result;
  }

  DatabaseHelper.make();
}
