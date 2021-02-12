import 'dart:ui';

import 'package:app_deteccion_personas/src/blocs/provider.dart';
import 'package:app_deteccion_personas/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:app_deteccion_personas/src/providers/device_provider.dart';
import 'package:app_deteccion_personas/src/providers/network_provider.dart';
import 'package:app_deteccion_personas/src/providers/user_provider.dart';
import 'package:app_deteccion_personas/src/providers/auth_provider.dart';
import 'package:app_deteccion_personas/src/utils/utils.dart' as utils;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _prefs = PreferenciasUsuario();
  final userProvider = new UserProvider();
  final networkProvider = new NetworkProvider();
  final deviceProvider = new DeviceProvider();
  final usuarioProvider = new AuthProvider();
  bool _obscureText = true;
  IconData _iconPassword = Icons.remove_red_eye_outlined;
  bool _isButtonEnable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(builder: (context) =>
          Stack(children: [_crearFondo(context), _loginForm(context)]),
    ));
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final circulo = Container(
      width: size.width * 0.57,
      height: size.width * 0.57,
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: utils.getColor('color2t1'),
                blurRadius: 2.0,
                spreadRadius: 3.0)
          ],
          borderRadius: BorderRadius.circular(size.width * 0.6),
          color: utils.getColor('color2t1')),
    );

    final fondo = Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: utils.getColor('color2')),
    );

    return Stack(
      children: [
        fondo,
        Positioned(child: circulo, top: -40.0, left: -40.0),
        Positioned(child: circulo, top: 150.0, right: -90.0),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 40.0), // 40
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromRGBO(247, 243, 241, 1.0),
                  radius: size.height * 0.1, // h: 0.1
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Image(
                      height: size.height * 0.14,
                      width: size.height * 0.14,
                      fit: BoxFit.fill,
                      image: AssetImage('assets/ic_splash.png'),
                    ),
                  ),
                ),
                SizedBox(height: 10.0, width: double.infinity),
                Text('Iniciar Sesión', style: TextStyle(
                    color: Color.fromRGBO(168, 97, 93, 1.0),
                        fontWeight: FontWeight.bold, fontSize: 25.0)) // 25
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child:
              Container(height: (40.0 + (3 * 25.0) + size.height * 0.2))),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(247, 243, 241, 1.0),
                borderRadius: BorderRadius.circular(7.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                SizedBox(height: 30.0),
                _userInput(bloc),
                SizedBox(height: 30.0),
                _passwordInput(bloc),
                SizedBox(height: 10.0),
                _textRecovery(),
                SizedBox(height: 40.0),
                _makeButton(bloc),
                SizedBox(height: 30.0),
                _registerOption()
              ],
            ),
          ),
          SizedBox(height: 50.0)
        ],
      ),
    );
  }

  Widget _userInput(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.userStream,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeUser,
          autofocus: false,
          decoration: InputDecoration(
            labelText: 'Usuario',
            hintText: 'Correo',
            errorText: snapshot.error,
            icon: Icon(Icons.account_circle),
          ),
        );
      },
    );
  }

  Widget _passwordInput(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (context, snapshot) {
        return TextField(
          obscureText: _obscureText,
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            hintText: 'Contraseña',
            labelText: 'Contraseña',
            errorText: snapshot.error,
            suffixIcon: IconButton(
              icon: new Icon(_iconPassword),
              onPressed: () => setState(() {
                _iconPassword = (_obscureText)
                    ? Icons.remove_red_eye
                    : Icons.remove_red_eye_outlined;
                _obscureText = !_obscureText;
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _textRecovery() {
    return Row(
      children: [
        Expanded(child: Container()),
        InkWell(
          child: Text("¿Olvidaste Tu Contraseña?",
              style: TextStyle(color: Color.fromRGBO(168, 97, 93, 1.0))),
          onTap: () => print("¿Olvidaste tu contraseña?"),
        ),
      ],
    );
  }

  Widget _makeButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (context, snapshot) {
        return RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Container(child: Text('Ingresar')),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.0,
          color: Color.fromRGBO(138, 67, 63, 1.0),
          textColor: Colors.white,
          onPressed: (snapshot.hasData && _isButtonEnable)
              ? () => _login(context, bloc)
              : null,
        );
      },
    );
  }

  _login(context, LoginBloc bloc) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      utils.snackBarMessage(context, "Sin conexion");
    } else {
      setState(() => _isButtonEnable = false);
      try {
        final info = await usuarioProvider.login(bloc.user, bloc.password);
        if (info['ok']) {
          Future.delayed(Duration(seconds: 3), () {}).then((value) {
            setState(() => _isButtonEnable = true);
          });
          final userToLogin = await userProvider.getUserByName(bloc.user);
          _prefs.nombreUsuario = bloc.user;
          if (userToLogin == null) {
            Navigator.pushReplacementNamed(context, 'network');
          } else {
            final networkName = await networkProvider
                .obtenerNetworkByToken(userToLogin.networkId);
            _prefs.tokenNetwork = userToLogin.networkId;
            _prefs.nombreNetwork = networkName;
            final deviceCreated = await deviceProvider.crearDevice(
                _prefs.tokenNetwork, _prefs.fcmToken);
            print(deviceCreated);
            Navigator.pushReplacementNamed(context, 'home');
          }
        } else {
          Future.delayed(Duration(seconds: 1), () {}).then((value) {
            setState(() => _isButtonEnable = true);
          });
          utils.mostrarAlerta(context,
              title: 'Error', content: info['mensaje']);
        }
      } catch (e) {
        print(e);
        Future.delayed(Duration(seconds: 1), () {}).then((value) {
          setState(() => _isButtonEnable = true);
        });
        _prefs.nombreUsuario = '';
        _prefs.tokenNetwork = '';
        _prefs.nombreNetwork = '';
        utils.mostrarAlerta(context,
            title: 'Error', content: 'Error inesperado');
      }
    }
  }

  Widget _registerOption() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      FlatButton(
          child: Text('crear una cuenta nueva',
              style: TextStyle(color: utils.getColor('color4'))),
          onPressed: () => Navigator.pushReplacementNamed(context, 'register')),
    ]);
  }
}
