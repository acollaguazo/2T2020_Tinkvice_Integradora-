import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del _colorSecundario
  get colorSecundario => _prefs.getBool('colorSecundario') ?? false;
  set colorSecundario( bool value ) => _prefs.setBool('colorSecundario', value);

  // GET y SET del _fcmToken
  get fcmToken =>  _prefs.getString('FCMToken') ?? '';
  set fcmToken( String value ) => _prefs.setString('FCMToken', value);

  // GET y SET del _tokenNetwork
  get tokenNetwork => _prefs.getString('tokenNetwork') ?? '';
  set tokenNetwork( String value ) => _prefs.setString('tokenNetwork', value);
  
  // GET y SET del _nameNetwork
  get nombreNetwork =>  _prefs.getString('nombreNetwork') ?? '';
  set nombreNetwork( String value ) => _prefs.setString('nombreNetwork', value);

  // GET y SET del nombreUsuario
  get nombreUsuario => _prefs.getString('nombreUsuario') ?? '';
  set nombreUsuario( String value ) => _prefs.setString('nombreUsuario', value);

  // GET y SET del currentIndex
  get currentIndex => _prefs.getInt('currentIndex') ?? 1;
  set currentIndex( int value ) => _prefs.setInt('currentIndex', value);

  // GET y SET del currentIndex
  get snackbarActive => _prefs.getBool('snackbarActive') ?? false;
  set snackbarActive( bool value ) => _prefs.setBool('snackbarActive', value);

}


