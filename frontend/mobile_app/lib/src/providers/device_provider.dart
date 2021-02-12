import 'package:http/http.dart' as http;

class DeviceProvider {
  
  DeviceProvider();

  final String _url =
      'https://us-central1-backendapptinkvice.cloudfunctions.net/app';

  Future<bool> crearDevice(String network, String token) async {
    final url = '$_url/api/devices';
    await http
        .post(url, body: {"network_id": network, "device_token": token});
    return true;
  }

  Future<bool> eliminarDevice(String token) async {
    final url = '$_url/api/devices/$token';
    await http.delete(url);
    return true;
  }
}
