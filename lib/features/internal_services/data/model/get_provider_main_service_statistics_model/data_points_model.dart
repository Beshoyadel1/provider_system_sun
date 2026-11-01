import 'package:sun_web_system/core/api/api_json.dart';
class DataPointsModel {
  final String? label;
  final int? value;

  DataPointsModel({
    this.label,
    this.value,
  });
  factory DataPointsModel.fromJson(
      Map<String, dynamic> json) {
    json = ApiJson.object(json);

    return DataPointsModel(
      label:
      json["label"]?.toString() ?? "",

      value:
      json["value"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "label": label??"",
      "value": value??0,
    };
  }
}
