import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:app_deteccion_personas/src/blocs/validators.dart';

class LoginBloc with Validators {
  final _userController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // get data from Stream
  Stream<String> get userStream =>
      _userController.stream.transform(validarUser);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  // RXDART combinelatest
  Stream<bool> get formValidStream =>
      Rx.combineLatest2(userStream, passwordStream, (e, p) => true);

  // add values to Stream
  Function(String) get changeUser => _userController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // get the last value in streams
  String get user => _userController.value;
  String get password => _passwordController.value;
  
  set password(String reset) => _passwordController.value = reset;

  dispose() {
    _userController.close();
    _passwordController.close();
  }
}
