import 'package:app_deteccion_personas/src/blocs/provider.dart';
import 'package:app_deteccion_personas/src/providers/auth_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart' as utils;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  IconData _iconPassword = Icons.remove_red_eye_outlined;
  final usuarioProvider = new AuthProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [_crearFondo(context), _loginForm(context)],
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
                color: utils.getColor('color4t4t1'),
                blurRadius: 2.0,
                spreadRadius: 3.0)
          ],
          borderRadius: BorderRadius.circular(size.width * 0.6),
          color: utils.getColor('color4t4t1')),
    );

    final fondo = Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(color: utils.getColor('color4t4')),
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
                Text('Registro',
                    style: TextStyle(
                        color: utils.getColor('color5'),
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)) // 25
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
          SafeArea(
              child:
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
                SizedBox(height: 50.0),
                _makeButton(bloc),
                SizedBox(height: 50.0),
                _makeRegisterButton()
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
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          onChanged: bloc.changeUser,
          autofocus: false,
          decoration: InputDecoration(
            labelText: 'Usuario',
            hintText: 'Ingresar correo',
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
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return TextField(
          obscureText: _obscureText,
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            icon: Icon(Icons.lock),
            labelText: 'Contraseña',
            hintText: 'Ingresar contraseña',
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

  Widget _makeButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Container(child: Text('Crear Cuenta')),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.0,
          color: Color.fromRGBO(138, 67, 63, 1.0),
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _register(context, bloc) : null,
        );
      },
    );
  }

  _register(BuildContext context, LoginBloc bloc) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      utils.snackBarMessage(context, "Sin conexion");
    } else {
      Map info = await usuarioProvider.nuevoUsuario(bloc.user, bloc.password);
      if (info['ok'])
        Navigator.pushReplacementNamed(context, 'login');
      else
        utils.mostrarAlerta(context, title: 'Error', content: info['mensaje']);
    }
  }

  Widget _makeRegisterButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      FlatButton(
          child: Text('¿Ya tienes una cuenta?'),
          onPressed: () => Navigator.pushReplacementNamed(context, 'login')),
    ]);
  }
}
