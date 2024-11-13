import 'package:flutter/material.dart';
import 'package:simplenote_flutter/pages/home/home_page.dart';
import 'dart:io' show Platform;
import 'package:window_manager/window_manager.dart';

void main() {
  runApp(const MyApp());

  // Hide the title bar on linux platforms
  if (Platform.isLinux) {
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplenote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
