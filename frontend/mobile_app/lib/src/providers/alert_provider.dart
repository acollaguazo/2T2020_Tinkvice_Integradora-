import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:app_deteccion_personas/src/models/alert_model.dart';
import 'package:app_deteccion_personas/src/preferencias_usuario/preferencias_usuario.dart';

class AlertProvider {

  final _prefs = PreferenciasUsuario();

  AlertProvider();

  final _url = 'https://us-central1-backendapptinkvice.cloudfunctions.net/app';

  Future<dynamic> cargarAlerts() async {
    final url = '$_url/api/network/${_prefs.tokenNetwork}/alerts';
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await Future.delayed(Duration(milliseconds: 500)); // for animation
      return Future.error('Sin conexion');
    } else {
      final resp = await http.get(url);
      final List<dynamic> decodedData = json.decode(resp.body);
      final alerts = new Alerts.fromJsonList(decodedData);
      return alerts.items;
    }
  }
}
