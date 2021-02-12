
import 'dart:convert';

NetworkModel networkModelFromJson(String str) => NetworkModel.fromJson(json.decode(str));

String networkModelToJson(NetworkModel data) => json.encode(data.toJson());

class NetworkModel {
    NetworkModel({
        this.name,
        this.id,
    });

    String name;
    String id;

    factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
    };
}
