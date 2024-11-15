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

  factory Note.newNote() {
    return Note(
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

  void saveLocalNote() {}

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
}
