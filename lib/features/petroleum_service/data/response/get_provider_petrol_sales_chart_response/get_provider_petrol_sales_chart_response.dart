import 'package:sun_web_system/features/petroleum_service/data/model/get_provider_petrol_sales_chart_model/petrol_chart_point.dart';

class GetProviderPetrolSalesChartResponse {
  final List<PetrolChartPoint> dataPoints;

  GetProviderPetrolSalesChartResponse({
    required this.dataPoints,
  });

  factory GetProviderPetrolSalesChartResponse.fromJson(
      Map<String, dynamic> json) {

    final data = json['data'];

    return GetProviderPetrolSalesChartResponse(
      dataPoints:
      (data['dataPoints'] as List<dynamic>?)
          ?.map((e) =>
          PetrolChartPoint.fromJson(
              e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}