import 'package:sun_web_system/features/petroleum_service/data/model/get_provider_petrol_sales_chart_model/petrol_chart_point.dart';

class GetProviderPetrolSalesChartResponse {
  final List<PetrolChartPoint> dataPoints;

  GetProviderPetrolSalesChartResponse({
    required this.dataPoints,
  });

  factory GetProviderPetrolSalesChartResponse.fromJson(
      Map<String, dynamic> json) {
    return GetProviderPetrolSalesChartResponse(
      dataPoints: (json['dataPoints'] as List)
          .map((e) => PetrolChartPoint.fromJson(e))
          .toList(),
    );
  }
}
