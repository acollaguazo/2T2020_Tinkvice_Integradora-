import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:app_deteccion_personas/src/utils/utils.dart' as utils;
import 'package:app_deteccion_personas/src/providers/image_provider.dart';

class UploadMapPage extends StatefulWidget {
  @override
  _UploadMapPageState createState() => _UploadMapPageState();
}

class _UploadMapPageState extends State<UploadMapPage> {
  File _image;
  int _piso = 0;
  bool _enableFAB = false;
  PickedFile foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.getColor('color1'),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Cargar Plano'),
        backgroundColor:
            (!_enableFAB) ? Colors.grey : utils.setColor('color6', 'color5'),
        icon: Icon(Icons.upload_file),
        onPressed: (!_enableFAB)
            ? null
            : () async {
                final imageProvider = new ImagenProvider();
                String pisoExist =
                    await imageProvider.cargarImageByPiso(_piso.toString());
                await imageProvider.subirImagen(
                    _image, _piso.toString(), pisoExist);
                Navigator.pushReplacementNamed(context, 'home');
              },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _seleccionarFoto,
            icon: Icon(Icons.image),
          )
        ],
        backgroundColor: utils.setColor('color6', 'color5'),
        title: Text('Cargar Plano'),
      ),
      body: Stack(
        children: [
          mostrarFoto(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                textColor: Colors.white,
                padding: EdgeInsets.all(12.0),
                shape: CircleBorder(),
                color: utils.setColor('color6t5', 'color5'),
                splashColor: Colors.white,
                onPressed: () {
                  if (_piso != 0) _piso = (_piso - 1);
                  setState(() {});
                },
                child: Icon(Icons.arrow_back),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.all(12.0),
                color: utils.setColor('color6t5', 'color5'),
                child: Text(
                  (_piso.toString() == '0') ? 'PB' : '${_piso}P',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              FlatButton(
                textColor: Colors.white,
                padding: EdgeInsets.all(12.0),
                shape: CircleBorder(),
                color: utils.setColor('color6t5', 'color5'),
                splashColor: Colors.white,
                onPressed: () {
                  setState(() => _piso = (_piso + 1));
                },
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _seleccionarFoto() async {
    final picker = ImagePicker();
    try {
      foto = await picker.getImage(source: ImageSource.gallery);
      if (foto == null) {
        print('No image selected.');
      } else {
        _image = File(foto.path);
        _enableFAB = true;
      }
    } catch (e) {
      print('Acceso denegado');
    }
    setState(() {});
  }

  Widget mostrarFoto(BuildContext context) {
    if (foto != null) {
      return Container(
        padding: EdgeInsets.all(20.0),
        height: double.infinity,
        width: double.infinity,
        child: Image.file(
          _image,
          fit: BoxFit.cover,
        ),
      );
    }
    return Expanded(
        child: utils.iconFont(Icons.image, context,
            'Para abrir la galería selecciona el ícono que aparece en la esquina superior derecha'));
  }
}
