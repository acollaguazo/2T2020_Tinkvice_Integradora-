import 'dart:convert';
import 'dart:io';
import 'package:app_deteccion_personas/src/models/image_model.dart';
import 'package:app_deteccion_personas/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class ImagenProvider {
  final _prefs = PreferenciasUsuario();
  final String _url =
      'https://us-central1-backendapptinkvice.cloudfunctions.net/app';

  Future<String> subirImagen(File imagen, String piso, String pisoExist) async {
    final urlclodinary = Uri.parse(
        'https://api.cloudinary.com/v1_1/dyit8ftt7/image/upload?upload_preset=usgahwzi');
    final mimeType = mime(imagen.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', urlclodinary);
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    final respData = json.decode(resp.body);
    if (pisoExist == '') {
      final url = '$_url/api/network/${_prefs.tokenNetwork}/images';
      await http.post(url, body: {"url": respData['secure_url'], "piso": piso});
      return respData['secure_url'];
    } else {
      await actualizarURL(piso.toString(), respData['secure_url']);
      return respData['secure_url'];
    }
  }

  Future<List<ImageModel>> cargarImages() async {
    final url = '$_url/api/network/${_prefs.tokenNetwork}/images';
    final result = await http.get(url);
    if (result.statusCode != 200)
      return [];
    else {
      final List<dynamic> decodedData = json.decode(result.body);
      final images = Images.fromJsonList(decodedData);
      return images.items;
    }
  }

  Future<String> cargarImageByPiso(String piso) async {
    final url = '$_url/api/network/${_prefs.tokenNetwork}/Images/$piso';
    final resp = await http.get(url);
    if ( resp.statusCode == 200 ) {
      final decodedData = json.decode(resp.body);
      return decodedData['data']['url'];
    }
      return '';
  }

  Future<bool> actualizarURL(String piso, String url) async {
    final url1 = '$_url/api/network/${_prefs.tokenNetwork}/Images/url';
    await http.put(url1, body: {"piso": piso, "url": url});
    return true;
  }
}
