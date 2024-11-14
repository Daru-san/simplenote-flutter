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

  Future<Data> getLocalData() async {
    var email = await storage.read(key: 'email');

    return Data(email: email.toString(), authtoken: "");
  }

  factory Data.newData() {
    return Data(email: "", authtoken: "");
  }

  Future<http.Response> sendData(String email, String password) async {
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

    var email = await storage.read(key: 'email');
    var password = await storage.read(key: 'password');

    var response = sendData(email.toString(), password.toString());

    return Data(email: email.toString(), authtoken: response.toString());
  }
}
