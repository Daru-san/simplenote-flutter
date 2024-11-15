import 'package:flutter/material.dart';
import 'package:simplenote_flutter/models/database/database.dart';
import 'package:simplenote_flutter/models/session/session.dart';
import 'package:simplenote_flutter/pages/main/main_page.dart';
import 'package:yaru/yaru.dart';

var currentSession = Session.newSession();
var noteDB = DatabaseHelper.make();

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();

  // currentSession = await currentSession.syncSimplenote();
  noteDB.initDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) {
        return MaterialApp(
          title: 'Simplenote',
          debugShowCheckedModeBanner: false,
          theme: yaru.theme,
          darkTheme: yaru.darkTheme,
          home: const MainPage(),
        );
      },
    );
  }
}
