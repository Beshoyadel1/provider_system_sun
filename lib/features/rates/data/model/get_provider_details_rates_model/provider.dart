import 'package:sun_web_system/core/api/api_json.dart';
class Provider {
  final int? id;
  final String? name;
  final String? latinName;
  final String? image;

  Provider({
    this.id,
    this.name,
    this.latinName,
    this.image,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    json = ApiJson.object(json);
    return Provider(
      id: json['id'],
      name: json['name'] ?? '',
      latinName: json['latinname'] ?? '',
      image: json['image'],
    );
  }
}
