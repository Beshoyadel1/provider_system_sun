import 'package:sun_web_system/core/api/api_json.dart';
import '../../model/get_provider_harage_sales_chart_model/harag_data_points_model.dart';

class GetProviderHarageDataPointsResponse {
  final List<HaragDataPointsModel> dataPoints;

  GetProviderHarageDataPointsResponse({
    required this.dataPoints,
  });

  factory GetProviderHarageDataPointsResponse.fromJson(
      Map<String, dynamic> json) {
    json = ApiJson.object(json);

    final data = json['data'];

    return GetProviderHarageDataPointsResponse(
      dataPoints:
      (data['dataPoints'] as List<dynamic>?)
          ?.map((e) => HaragDataPointsModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}
