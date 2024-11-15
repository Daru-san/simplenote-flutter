import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:simplenote_flutter/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        platform: DevicePlatform.linux,
        sections: [
          SettingsSection(
            title: const Text("Simplenote"),
            tiles: [
              SettingsTile.navigation(
                title: const Text("Login to simplenote"),
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
              SettingsTile(
                title: Text("Sync with simplenote"),
                onPressed: (context) async {
                  currentSession = await currentSession.syncSimplenote();
                },
              ),
              SettingsTile(title: Text("Email: ${currentSession.email}")),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passswordTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login to simplenote"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailTextController,
              decoration: const InputDecoration(
                hintText: 'Enter email',
                isDense: true,
              ),
            ),
            TextField(
              controller: _passswordTextController,
              enableSuggestions: false,
              obscureText: true,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter password',
                isDense: true,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                currentSession.setAuthInfo(
                  _emailTextController.text,
                  _passswordTextController.text,
                );
                currentSession.syncSimplenote();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
