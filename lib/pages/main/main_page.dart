import 'package:flutter/material.dart';
import 'package:simplenote_flutter/api/data.dart';
import 'package:simplenote_flutter/pages/home/home_page.dart';
import 'package:simplenote_flutter/pages/settings/settings_page.dart';
import 'package:simplenote_flutter/pages/tags/tag_page.dart';
import 'package:yaru/yaru.dart';

var userData = Data.newData();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int _activePage = 0;
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

  void syncData() async {
    var localData = userData.getLocalData();
    userData = await (await localData).syncSimplenote();
  }

  @override
  Widget build(BuildContext context) {
    syncData();

    return Scaffold(
      appBar: YaruWindowTitleBar(
        title: Text(_pageTitles[_activePage]),
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
          setState(() {
            _activePage = index;
          });
          return Center(child: _pages[index]);
        },
      ),
    );
  }
}
