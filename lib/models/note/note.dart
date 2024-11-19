import 'package:simplenote_flutter/main.dart';

class Note {
  final int id;
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
    required this.id,
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

  factory Note.newNote() {
    return Note(
      id: 0,
      key: "",
      content: "",
      modifydate: DateTime.now(),
      createdate: DateTime.now(),
      systemtags: [],
      tags: [],
      syncnum: 0,
      version: 0,
      isDeleted: false,
    );
  }

  void saveLocalNote() async {
    if (await noteDB.checkNote(id)) {
      noteDB.updateNote(this);
    } else {
      noteDB.insertNote(this);
    }
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'key': String key,
        'content': String content,
        'modifydate': int modifydate,
        'createdate': int createdate,
        'syncnum': int syncnum,
        'version': int version,
        'systemtags': List<String> systemtags,
        'tags': List<String> tags,
        'isDeleted': bool isDeleted,
      } =>
        Note(
          id: 0,
          key: key,
          content: content,
          modifydate: DateTime.fromMillisecondsSinceEpoch(
            Duration(seconds: modifydate).inMilliseconds,
          ),
          createdate: DateTime.fromMillisecondsSinceEpoch(
            Duration(seconds: createdate).inMilliseconds,
          ),
          systemtags: systemtags,
          tags: tags,
          syncnum: syncnum,
          version: version,
          isDeleted: isDeleted,
        ),
      _ => throw Exception("Failed to load note."),
    };
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['key'] = key;
    map['content'] = content;
    map['modified_date'] = Duration(
      milliseconds: modifydate.millisecondsSinceEpoch,
    ).inSeconds;
    map['creation_date'] = Duration(
      milliseconds: createdate.millisecondsSinceEpoch,
    ).inSeconds;

    map['id'] = (id != 0) ? id : 0;

    return map;
  }

  Note setId(int newID) {
    return Note(
      id: newID,
      key: key,
      content: content,
      modifydate: modifydate,
      createdate: createdate,
      systemtags: systemtags,
      tags: tags,
      syncnum: syncnum,
      version: version,
      isDeleted: isDeleted,
    );
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'id': int id,
        'key': String key,
        'content': String content,
        'modified_date': int modifydate,
        'creation_date': int createdate,
      } =>
        Note(
            id: id,
            key: key,
            content: content,
            modifydate: DateTime.fromMillisecondsSinceEpoch(
              Duration(seconds: modifydate).inMilliseconds,
            ),
            createdate: DateTime.fromMillisecondsSinceEpoch(
              Duration(seconds: createdate).inMilliseconds,
            ),
            systemtags: [],
            tags: [],
            syncnum: 0,
            version: 0,
            isDeleted: false),
      _ => throw Exception('Error converting note')
    };
  }
}
