import 'package:sun_web_system/core/api/api_json.dart';
import '../dashboard_service.dart';

class GetProviderOrdersSalesModel {
  final List<DataPoint> dataPoints;
  GetProviderOrdersSalesModel({required this.dataPoints});

  factory GetProviderOrdersSalesModel.fromJson(Map<String, dynamic> json) {
    final data = ApiJson.object(json)['data'];
    if (data is! Map) throw const FormatException('Invalid sales response');
    final points = ApiJson.object(data)['dataPoints'];
    if (points is! List) throw const FormatException('Invalid sales points');
    return GetProviderOrdersSalesModel(
        dataPoints: points.asMap().entries.map((entry) {
      final e = entry.value;
      // The documentation also allows a plain numeric sequence. Its labels
      // are ordinals, never invented dates.
      if (e is num && e.isFinite) {
        return DataPoint(label: '${entry.key + 1}', value: e.toDouble());
      }
      if (e is! Map) throw const FormatException('Invalid sales point');
      return DataPoint.fromJson(Map<String, dynamic>.from(e));
    }).toList());
  }
}

class DataPoint {
  final String label;
  final double value;
  const DataPoint({required this.label, required this.value});

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    final data = ApiJson.object(json);
    final label = data['label'] ?? data['date'];
    final value = dashboardNumber(data['value']);
    if (label is! String || label.isEmpty || value == null) {
      throw const FormatException('Invalid sales point');
    }
    return DataPoint(label: label, value: value);
  }
}
