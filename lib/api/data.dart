import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = const FlutterSecureStorage();

class Data {
  final String email;
  final String authtoken;

  Data({
    required this.email,
    required this.authtoken,
  });

  void setAuthInfo(String authtoken, String email) async {
    await storage.write(key: 'authtoken', value: authtoken);
    await storage.write(key: 'email', value: email);
  }

  static Future<Data> fetch() async {
    var authtoken = await storage.read(key: 'authtoken');
    var email = await storage.read(key: 'email');

    return Data(email: email.toString(), authtoken: authtoken.toString());
  }
}
