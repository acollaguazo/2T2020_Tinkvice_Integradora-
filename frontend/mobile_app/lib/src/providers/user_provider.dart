import 'dart:convert';
import 'package:app_deteccion_personas/src/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  UserProvider();

  final String _url =
      'https://us-central1-backendapptinkvice.cloudfunctions.net/app';

  Future<bool> crearUser(String user, String token) async {
    final url = '$_url/api/users';
    await http.post(url, body: {"user": user, "network_id": token});
    return true;
  }

  Future<UserModel> getUserByName(String name) async {
    final url = '$_url/api/name/$name/users';
    final resp = await http.get(url);
    List decodedData = json.decode(resp.body);
    if (decodedData.isEmpty) return null;

    final user = UserModel.fromJson(decodedData[0]);
    return user;
  }
}
