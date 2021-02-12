import 'dart:convert';

ApModel wlcModelFromJson(String str) => ApModel.fromJson(json.decode(str));

String wlcModelToJson(ApModel data) => json.encode(data.toJson());

class ApModel {
  String wlcId;
  String networkId;
  String mac;
  String model;
  String name;
  String piso;
  String devices;
  String limit;
  String active;
  String dx;
  String dy;

  ApModel({
    this.wlcId,
    this.networkId,
    this.mac,
    this.model,
    this.name,
    this.piso,
    this.devices,
    this.limit,
    this.active,
    this.dx,
    this.dy,
  });

  factory ApModel.fromJson(Map<String, dynamic> json) => ApModel(
    wlcId: json["wlc_id"],
    networkId: json["network_id"],
    mac: json["mac"],
    model: json["model"],
    name: json["name"],
    piso: json["piso"],
    devices: json["devices"],
    limit: json["limit"],
    active: json["active"],
    dx: json["dx"],
    dy: json["dy"],
  );

  Map<String, dynamic> toJson() => {
    "wlc_id": wlcId,
    "network_id": networkId,
    "mac": mac,
    "model": model,
    "name": name,
    "piso": piso,
    "devices": devices,
    "limit": limit,
    "active": active,
    "dx": dx,
    "dy": dy,
  };
}

class Aps {
  List<ApModel> items = new List();

  Aps();

  Aps.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final ap = new ApModel.fromJson(item);
      items.add(ap);
    }
  }
}
