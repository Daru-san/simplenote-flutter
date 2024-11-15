import 'package:flutter/material.dart';
import 'package:simplenote_flutter/pages/home/home_page.dart';
import 'package:simplenote_flutter/pages/settings/settings_page.dart';
import 'package:simplenote_flutter/pages/tags/tag_page.dart';
import 'package:yaru/yaru.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    TagPage(),
    SettingsPage(),
  ];

  static const List<String> _pageTitles = <String>[
    "Home",
    "Tags",
    "Settings",
  ];

  static const List<IconData> _pageIcons = <IconData>[
    YaruIcons.home,
    YaruIcons.tag,
    YaruIcons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text('Simplenote'),
        isMinimizable: false,
        isRestorable: false,
        isClosable: false,
        isMaximizable: false,
      ),
      body: YaruMasterDetailPage(
        length: _pages.length,
        tileBuilder: (context, index, selected, avaiableWidth) {
          return YaruMasterTile(
            leading: Icon(_pageIcons[index]),
            title: Text(_pageTitles[index]),
          );
        },
        pageBuilder: (context, index) {
          return Center(child: _pages[index]);
        },
      ),
    );
  }
}
