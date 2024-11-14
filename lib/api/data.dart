import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = const FlutterSecureStorage();

class Data {
  final String email;
  final String authtoken;

  Data({
    required this.email,
    required this.authtoken,
  });

  void setAuthInfo(String email, String password) async {
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
  }

  Future<Data> getUserAuthData() async {
    String lastCheckDateStr =
        (await storage.read(key: 'lastChecked')).toString();

    DateTime lastChecked = DateTime.tryParse(lastCheckDateStr) ?? DateTime(0);

    if (DateTime.now().difference(lastChecked) > Duration(days: 1)) {
      return syncSimplenote();
    } else {
      var email = await storage.read(key: 'email');
      var authtoken = await storage.read(key: 'authtoken');
      return Data(email: email.toString(), authtoken: authtoken.toString());
    }
  }

  factory Data.newData() {
    return Data(email: "", authtoken: "");
  }

  Future<http.Response> sendAuthRequest(String email, String password) async {
    final body =
        utf8.encode("email=${email.trim()}&password=${password.trim()}");
    return http.post(
      Uri.parse("https://simple+note.appspot.com/api/login"),
      headers: <String, String>{
        "Content-Type": "text/plain",
      },
      body: base64Encode(body),
    );
  }

  Future<Data> syncSimplenote() async {
    var email = await storage.read(key: 'email');
    var password = await storage.read(key: 'password');
    var authtoken = "none";
    var response = await sendAuthRequest(email.toString(), password.toString());

    switch (response.statusCode) {
      case 200:
        () async {
          await storage.write(
            key: 'lastChecked',
            value: DateTime.now().toString(),
          );
          await storage.write(key: 'authkey', value: response.toString());
          authtoken = response.body;
        };
      default:
      //TODO: Show message on failure
    }
    return Data(email: email.toString(), authtoken: authtoken);
  }
}
