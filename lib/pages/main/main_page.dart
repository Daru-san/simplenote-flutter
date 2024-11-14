import 'package:flutter/material.dart';
import 'package:simplenote_flutter/api/data.dart';
import 'package:simplenote_flutter/pages/home/home_page.dart';
import 'package:simplenote_flutter/pages/settings/settings_page.dart';
import 'package:simplenote_flutter/pages/tags/tag_page.dart';

var userData = Data.newData();

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

//TODO: Check if a user is logged in, if not, send them to log in
void getData() async {
  var data = userData.getData();
  userData = await data;
}

class _MainPageState extends State<MainPage> {
  int _activePage = 0;
  String _appTile = "Home";

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    TagPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appTile),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _activePage,
            onDestinationSelected: (int index) {
              setState(() {
                _activePage = index;
                _appTile = _pages[index].toString();
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.tag_outlined),
                selectedIcon: Icon(Icons.tag),
                label: Text('Tags'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_pages[_activePage]],
            ),
          )
        ],
      ),
    );
  }
}
