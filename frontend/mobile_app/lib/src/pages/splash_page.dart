import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:app_deteccion_personas/src/pages/home_page.dart';
import 'package:app_deteccion_personas/src/pages/login_page.dart';
import 'package:app_deteccion_personas/src/pages/network_page.dart';
import 'package:app_deteccion_personas/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:app_deteccion_personas/src/providers/network_provider.dart';
import 'package:app_deteccion_personas/src/utils/utils.dart' as utils;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final NetworkProvider networkProvider = new NetworkProvider();
  final _prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 2,
      navigateAfterSeconds: selectPage(),
      title: new Text('Bienvenido a Tinkvice',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
      image: Image(image: AssetImage('assets/ic_splash.png')),
      backgroundColor: utils.getColor('color2'),
      loaderColor: Colors.red,
    );
  }

  Widget selectPage() {
    if (_prefs.nombreUsuario == '')
      return LoginPage();
    else {
      if (_prefs.tokenNetwork == '')
        return NetworkPage();
      else
        return HomePage();
    }
  }
}
