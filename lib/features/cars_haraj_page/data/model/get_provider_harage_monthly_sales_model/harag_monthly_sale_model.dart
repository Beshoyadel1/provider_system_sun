import 'package:sun_web_system/core/api/api_json.dart';
class HaragMonthlySaleModel {
  final String label;
  final num value;

  HaragMonthlySaleModel({
    required this.label,
    required this.value,
  });

  factory HaragMonthlySaleModel.fromJson(Map<String, dynamic> json) {
    json = ApiJson.object(json);
    return HaragMonthlySaleModel(
      label: json['label'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}
