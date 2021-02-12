import 'package:app_deteccion_personas/src/providers/ap_provider.dart';
import 'package:flutter/material.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'package:app_deteccion_personas/src/models/ap_model.dart';
import 'package:app_deteccion_personas/src/widgets/varios_widget.dart';
import 'package:app_deteccion_personas/src/providers/image_provider.dart';
import 'package:app_deteccion_personas/src/utils/utils.dart' as utils;

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final ImagenProvider imagenProvider = ImagenProvider();
  final ApProvider apProvider = ApProvider();
  TapPosition _position = TapPosition(Offset.zero, Offset.zero);
  double _yTop = 0.0;
  double _xLeft = 0.0;

  @override
  Widget build(BuildContext context) {
    final ApModel ap = ModalRoute.of(context).settings.arguments;
    final Size _screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constrainst) {
          return Stack(
            fit: StackFit.expand,
            children: [
              PositionedTapDetector(
                  onTap: (position) => _onTap(ap, position, _screenSize),
                  child: _setImagen(ap)),
              Positioned(
                top: (double.parse(ap.dy) * _screenSize.height / 100) - 25,
                left: (double.parse(ap.dx) * _screenSize.width / 100) - 25,
                child: Container(
                  child: Icon(Icons.add,
                      size: 50.0, color: utils.getColor('color4')),
                ),
              ),
              Positioned(
                bottom: 10.0,
                right: 10.0,
                child: FlatButton(
                  child: Text('Agregar',
                      style: TextStyle(color: utils.getColor('color1'))),
                  color: utils.getColor('color5'),
                  onPressed: () => _updatePosition(ap, _screenSize),
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 10.0,
                child: FlatButton(
                    child: Text('Regresar',
                        style: TextStyle(color: utils.getColor('color1'))),
                    color: utils.getColor('color5'),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, 'home')),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _setImagen(ApModel ap) {
    return FutureBuilder(
      future: imagenProvider.cargarImageByPiso(ap.piso),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: [
              utils.errorInfo(snapshot.error, Colors.red),
              utils.iconFont(Icons.wifi_off, context, '')
            ],
          );
        } else if (snapshot.data == '') {
            return Column(
              children: [
                utils.errorInfo('Sin Información', Colors.purple),
                Expanded(
                  child: utils.iconFont(Icons.error, context, 'Error, al cargar la imagen. Vuelve a intenterlo')
                )
              ],
            );
          } else if (snapshot.data != null ) {
            return FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'),
              fit: BoxFit.fill,
              image: NetworkImage(snapshot.data),
            );
        } else {
          return circularProgressIndicatorWidget();
        }
      },
    );
  }

  _onTap(ApModel ap, TapPosition position, Size size) => _updateState(ap, position, size);

  void _updateState(ApModel ap, TapPosition position,  Size size) {
    setState(() => _position = position);
    final offset = _position.relative;
    _yTop = double.parse(offset.dy.toStringAsFixed(1));
    _xLeft = double.parse(offset.dx.toStringAsFixed(1));

    ap.dx = ((_xLeft / size.width) * 100.0).round().toString();
    ap.dy = ((_yTop / size.height) * 100.0).round().toString();
    print(ap.dx);
    print(ap.dy);
    setState(() {});
  }

  void _updatePosition(ApModel ap, Size size) async {
    final int xPercent = ((_xLeft / size.width) * 100.0).round();
    final int yPercent = ((_yTop / size.height) * 100.0).round();
    print('x: $xPercent');
    print('y: $yPercent');
    apProvider.actualizarDxDy(ap.mac, xPercent.toString(), yPercent.toString());
  }
}
