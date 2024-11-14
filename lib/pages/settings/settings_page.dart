import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  final title = "Settings";

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return title;
  }

  @override
  State<SettingsPage> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
