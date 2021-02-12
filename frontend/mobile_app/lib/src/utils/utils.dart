import 'dart:ui';

import 'package:app_deteccion_personas/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';

final _prefs = PreferenciasUsuario();

mostrarAlerta(BuildContext context, {String title, String content}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(cambiarTexto(content)),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok',
                    style: TextStyle(color: Color.fromRGBO(10, 52, 68, 1.0))))
          ],
        );
      });
}

String cambiarTexto(String texto) {
  Map<String, String> mapa = {
    'MISSING_EMAIL': 'Error de inicio de sesión. Nombre de usuario o contraseña no válidos',
    'MISSING_PASSWORD': 'Error de inicio de sesión. Nombre de usuario o contraseña no válidos',
    'INVALID_EMAIL': 'Error de inicio de sesión. Nombre de usuario o contraseña no válidos',
    'INVALID_PASSWORD': 'Error de inicio de sesión. Nombre de usuario o contraseña no válidos',
    'EMAIL_NOT_FOUND': 'Error de inicio de sesión. Nombre de usuario o contraseña no válidos',
    'EMAIL_EXISTS': 'La cuenta de correo ya esta asociada, verifica que esta sea tu cuenta e inicia sesión',
    'TOO_MANY_ATTEMPTS_TRY_LATER : Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.': 'El acceso a esta cuenta se ha inhabilitado temporalmente debido a muchos intentos fallidos de inicio de sesión. Puede restaurarlo inmediatamente restableciendo su contraseña o puede intentarlo de nuevo más tarde.'
    };
  if (mapa.containsKey(texto)) return mapa[texto];
  return texto;
}

Color getColor(String color) {
  Map<String, Color> mapa = {
    'color1': Color.fromRGBO(247, 243, 241, 1.0),
    'color2': Color.fromRGBO(239, 218, 213, 1.0),
    'color2t1': Color.fromRGBO(225, 207, 202, 1.0),
    'color3': Color.fromRGBO(255, 199, 124, 1.0),
    'color3t1': Color.fromRGBO(255, 200, 144, 1.0),
    'color4': Color.fromRGBO(241, 94, 74, 1.0),
    'color4t4': Color.fromRGBO(248, 175, 165, 1.0), // tinte 4 de color4
    'color4t4t1': Color.fromRGBO(233, 169, 160, 1.0), // tinte 1 de color4t4
    'color5': Color.fromRGBO(168, 97, 93, 1.0),
    'color6': Color.fromRGBO(10, 52, 68, 1.0),
    'color6t5': Color.fromRGBO(133, 154, 162, 1.0), // tinte 5to de color6
    'black': Color.fromRGBO(0, 0, 0, 1.0), // tinte 5to de color6
  };
  if (mapa.containsKey(color)) return mapa[color];
  return mapa['color1'];
}

Color setColor(String secundario, String primario) {
  return (_prefs.colorSecundario) ? getColor(secundario) : getColor(primario);
}

Widget errorInfo(String mensaje, Color color) {
  return Container(
    padding: EdgeInsets.all(10.0),
    margin: EdgeInsets.only(bottom: 10.0),
    color: color,
    child: Row(children: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 10.0),
        child: Icon(Icons.info, color: Colors.white),
      ),
      Text(mensaje, style: TextStyle(color: Colors.white, fontSize: 16.0)),
    ]),
  );
}

Widget iconFont(IconData icono, BuildContext context, String texto) {
  final size = MediaQuery.of(context).size;
  return Container(
    height: double.infinity,
    width: double.infinity,
    padding: EdgeInsets.all(30.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Icon(icono, color: Colors.grey, size: size.width * 0.2),
      SizedBox(height: 10.0),
      Text(texto, textAlign: TextAlign.center, 
          style: TextStyle(fontSize: 16.0, color: Colors.grey))
      ],
    ),
  );
}

snackBarMessage(BuildContext context, String message) {
  if (!_prefs.snackbarActive) {
    _prefs.snackbarActive = true;
    Scaffold.of(context)
        .showSnackBar(SnackBar(
            content: Row(
          children: [Icon(Icons.info), SizedBox(width: 10.0), Text(message)],
        )))
        .closed
        .then((SnackBarClosedReason reason) {
      _prefs.snackbarActive = false;
    });
  }
}
