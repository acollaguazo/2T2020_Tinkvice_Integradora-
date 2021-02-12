
import 'package:app_deteccion_personas/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';

Widget circularProgressIndicatorWidget() {
  return Center(child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(utils.getColor('color5'))));
}