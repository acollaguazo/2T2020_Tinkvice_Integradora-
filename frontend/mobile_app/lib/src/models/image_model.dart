
import 'dart:convert';

ImageModel imageModelFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
    ImageModel({
        this.url,
        this.piso,
    });

    String url;
    int piso;

    factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        url  : json["url"],
        piso : int.parse(json["piso"]),
    );

    Map<String, dynamic> toJson() => {
        "url"  : url,
        "piso" : piso,
    };
}

class Images {
  List<ImageModel> items = new List();

  Images();

  Images.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final image = new ImageModel.fromJson(item);
      items.add(image);
    }
  }
}
