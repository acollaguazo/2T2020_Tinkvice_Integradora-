
import 'dart:convert';
import 'package:app_deteccion_personas/src/models/ap_model.dart';

WlcModel wlcModelFromJson(String str) => WlcModel.fromJson(json.decode(str));

String wlcModelToJson(WlcModel data) => json.encode(data.toJson());

class WlcModel {
  String networkId;
  String mac;
  String manufacturerName;
  String productName;
  List<ApModel> aps;

  WlcModel({this.networkId, this.mac, this.manufacturerName, this.productName});

  factory WlcModel.fromJson(Map<String, dynamic> json) => WlcModel(
      networkId: json["network_id"],
      mac: json["mac"],
      manufacturerName: json["manufacturer_name"],
      productName: json["product_name"]);

  Map<String, dynamic> toJson() => {
        "network_id": networkId,
        "mac": mac,
        "manufacturer_name": manufacturerName,
        "product_name": productName
      };
}

class Wlcs {
  List<WlcModel> items = new List();

  Wlcs();

  Wlcs.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final wlc = new WlcModel.fromJson(item);
      items.add(wlc);
    }
  }
}
