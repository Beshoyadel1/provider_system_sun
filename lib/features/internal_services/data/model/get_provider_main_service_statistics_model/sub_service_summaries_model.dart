import 'dart:convert';
import 'dart:typed_data';

class SubServiceSummariesModel {
  final String? serviceName;
  final String? serviceLatinName;
  final Uint8List? image;
  final int? orderCount;

  SubServiceSummariesModel({
    this.serviceName,
    this.serviceLatinName,
    this.image,
    this.orderCount,
  });
  factory SubServiceSummariesModel.fromJson(
      Map<String, dynamic> json) {

    return SubServiceSummariesModel(
      serviceName:
      json["serviceName"]?.toString() ?? "",

      serviceLatinName:
      json["serviceLatinName"]?.toString() ?? "",

      image: json["image"] != null
          ? base64Decode(json["image"])
          : null,

      orderCount:
      json["orderCount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "serviceName": serviceName??"",
      "serviceLatinName": serviceLatinName??"",
      "image": image != null ? base64Encode(image!) : null,
      "orderCount": orderCount,
    };
  }
}