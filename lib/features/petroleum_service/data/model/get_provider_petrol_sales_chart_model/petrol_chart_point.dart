import 'package:sun_web_system/core/api/api_json.dart';
class PetrolChartPoint {
  final String label;
  final num value;

  PetrolChartPoint({
    required this.label,
    required this.value,
  });

  factory PetrolChartPoint.fromJson(Map<String, dynamic> json) {
    json = ApiJson.object(json);
    return PetrolChartPoint(
      label: json['label'],
      value: json['value'],
    );
  }
}
