import 'package:flutter/material.dart';
import 'package:app_deteccion_personas/src/pages/datos_page.dart';
import 'package:app_deteccion_personas/src/pages/historial_page.dart';
import 'package:app_deteccion_personas/src/pages/planos_page.dart';
import 'package:app_deteccion_personas/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:app_deteccion_personas/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _prefs = new PreferenciasUsuario();
  int _currentIndex = 1;

  Widget build(BuildContext context) {
    _currentIndex = _prefs.currentIndex;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: utils.setColor('color6', 'color2'),
        title: Text('Tinkvice',
            style: TextStyle(color: utils.setColor('color1', 'color6'))),
        actions: [
          IconButton(
              icon: Icon(Icons.settings_outlined),
              color: utils.setColor('color1', 'color6'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'setting');
                setState(() {});
              }),
          SizedBox(width: 10.0),
        ],
        leading: Container(
          padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Image(
              fit: BoxFit.fill, image: AssetImage('assets/ic_appbar.png')),
        ),
        elevation: 5.0,
        titleSpacing: 6.0,
      ),
      body: _llamarPagina(_currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
    );
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
        backgroundColor: utils.setColor('color6', 'color2'),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        unselectedItemColor: Color.fromRGBO(168, 97, 93, 0.4),
        iconSize: 30.0,
        unselectedIconTheme: IconThemeData(size: 25.0),
        selectedItemColor: utils.setColor('color1', 'color5'),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _prefs.currentIndex = index;
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_searching), label: 'Principal'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business_sharp), label: 'Datos'),
        ]);
  }

  Widget _llamarPagina(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return HistorialPage();
      case 1:
        return PlanosPage();
      case 2:
        return InfoPage();
      default:
        return PlanosPage();
    }
  }
}
