
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:app_deteccion_personas/src/providers/device_provider.dart';
import 'package:app_deteccion_personas/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:app_deteccion_personas/src/utils/utils.dart' as utils;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _colorSecundario;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final deviceProvicer = DeviceProvider();
  final _prefs = PreferenciasUsuario();
  final _infoToken =
      'Úsalo en Tinkvice SSH para enviar la información de la red a la base de datos';

  @override
  void initState() {
    super.initState();
    _colorSecundario = _prefs.colorSecundario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: utils.getColor('color1'),
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'home');
                setState(() {});
              },
              icon: Icon(Icons.arrow_back_ios),
              color: utils.setColor('color1', 'color6')),
          title: Text('Información y ajustes',
              style: TextStyle(color: utils.setColor('color1', 'color6'))),
          centerTitle: true,
          backgroundColor: utils.setColor('color6', 'color2')),
      body: Builder(
        builder: (context) => ListView(
          children: [
            _subtitulo('Información'),
            _listtile(title: 'Usuario', trailing: _prefs.nombreUsuario),
            _listtile(title: 'Nombre de red', trailing: _prefs.nombreNetwork),
            _listtile(
                title: 'Token',
                trailing: _prefs.tokenNetwork,
                subtitle: _infoToken),
            _subtitulo('Ajustes'),
            _swtichListTile(),
            _cargarImagen(),
            _exitSession(context),
          ],
        ),
      ),
    );
  }

  Widget _listtile({String title, String trailing, String subtitle = ''}) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 0.1, color: Colors.grey)),
      child: ListTile(
          title: Text(title),
          subtitle: (subtitle != '') ? Text(subtitle) : null,
          trailing:
              Text(trailing, style: TextStyle(fontWeight: FontWeight.w300)),
          tileColor: Colors.white),
    );
  }

  Widget _subtitulo(String subtitulo) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
      child: Text(subtitulo,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _swtichListTile() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.1, color: Colors.grey)),
      child: ListTile(
        leading: Icon(Icons.color_lens),
        title: Text('Color secundario'),
        trailing: Switch(
            activeColor: utils.getColor('color6'),
            value: _colorSecundario,
            onChanged: (value) {
              setState(() {
                _colorSecundario = value;
                _prefs.colorSecundario = value;
              });
            }),
      ),
    );
  }

  Widget _exitSession(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      child: FlatButton(
          child: Text('Cerrar Sesión',
              style: TextStyle(color: utils.getColor('color1'))),
          color: utils.setColor('color6t5', 'color5'),
          onPressed: () async {
            final connectivityResult =
                await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.none) {
              utils.snackBarMessage(context, "Sin conexion");
            } else {
              _prefs.tokenNetwork = '';
              _prefs.nombreNetwork = '';
              _prefs.nombreUsuario = '';
              deviceProvicer.eliminarDevice(_prefs.fcmToken);
              Navigator.pushReplacementNamed(context, 'splash');
            }
          }),
    );
  }

  Widget _cargarImagen() {
    return ListTile(
      title: Text('Cargar Plano'),
      leading: Icon(Icons.image),
      tileColor: Colors.white,
      onTap: () => Navigator.pushNamed(context, 'upload_map'),
    );
  }
}
