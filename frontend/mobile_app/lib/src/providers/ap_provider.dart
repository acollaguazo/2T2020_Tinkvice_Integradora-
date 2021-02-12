import 'dart:convert';
import 'package:app_deteccion_personas/src/models/ap_model.dart';
import 'package:app_deteccion_personas/src/models/wlc_model.dart';
import 'package:app_deteccion_personas/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class ApProvider {
  final _prefs = PreferenciasUsuario();

  final String _url =
      'https://us-central1-backendapptinkvice.cloudfunctions.net/app';

  Future<List<ApModel>> cargarAps(String wlcId) async {
    final url = '$_url/api/wlc/$wlcId/aps';
    final resp = await http.get(url);
    final List<dynamic> decodedData = json.decode(resp.body);
    final aps = new Aps.fromJsonList(decodedData);
    return aps.items;
  }

  Future<List<ApModel>> cargarApsByNetwork(String networkId) async {
    final url = '$_url/api/network/$networkId/aps';
    final resp = await http.get(url);
    final List<dynamic> decodedData = json.decode(resp.body);
    final aps = new Aps.fromJsonList(decodedData);
    print(aps.items.length);
    return aps.items;
  }

  Future<List<dynamic>> cargarWlcsAps() async {
    final url = '$_url/api/network/${_prefs.tokenNetwork}/wlcs';
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      await Future.delayed(Duration(milliseconds: 500)); // for animation
      return Future.error('Sin conexion');
    } else {
      final resp = await http.get(url);
      final List<dynamic> decodedData = json.decode(resp.body);
      final wlcs = new Wlcs.fromJsonList(decodedData);
      List<WlcModel> lista = wlcs.items;
      for (WlcModel item in lista) {
        final url = '$_url/api/wlc/${item.mac}/aps';
        final resp = await http.get(url);
        final List<dynamic> decodedData = json.decode(resp.body);
        final aps = new Aps.fromJsonList(decodedData).items;
        item.aps = aps;
      }
      return wlcs.items;
    }
  }

  Future<bool> actualizarPisoLimite(
      String mac, String limite, String piso) async {
    final url = '$_url/api/aps/$mac/limit/piso';
    await http.put(url, body: {"limit": limite, "piso": piso});
    return true;
  }

  Future<bool> actualizarDxDy(String mac, String dx, String dy) async {
    final url = '$_url/api/aps/$mac/dxdy';
    await http.put(url, body: {"dx": dx, "dy": dy});
    return true;
  }
}
