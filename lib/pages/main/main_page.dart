import 'package:flutter/material.dart';
import 'package:simplenote_flutter/pages/home/home_page.dart';
import 'package:simplenote_flutter/pages/note/note_page.dart';
import 'package:simplenote_flutter/pages/settings/settings_page.dart';
import 'package:simplenote_flutter/pages/tags/tag_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int _activePage = 0;
  String _appTile = "Dashboard";

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    TagPage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
