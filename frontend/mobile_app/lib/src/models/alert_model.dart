
import 'dart:convert';

AlertModel wlcModelFromJson(String str) => AlertModel.fromJson(json.decode(str));

String wlcModelToJson(AlertModel data) => json.encode(data.toJson());

class AlertModel {
  String id;
  String networkId;
  String area;
  String deviceNumber;
  String date;
  String hour;

  AlertModel({this.networkId, this.area, this.deviceNumber, this.hour, this.date, this.id});

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
    id           : json["id"],
    networkId    : json["network_id"],
    area         : json["area"],
    deviceNumber : json["device_number"],
    hour         : json["hour"],
    date         : json["date"]
  );

  Map<String, dynamic> toJson() => {
    "id"            : id,
    "network_id"    : networkId,
    "area"          : area,
    "device_number" : deviceNumber,
    "hour"          : hour,
    "date"          : date
  };
}

class Alerts {
  List<AlertModel> items = new List();

  Alerts();

  Alerts.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final alert = new AlertModel.fromJson(item);
      items.add(alert);
    }
  }
}
