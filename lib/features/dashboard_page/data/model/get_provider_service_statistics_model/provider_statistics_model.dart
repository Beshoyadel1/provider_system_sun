import 'package:sun_web_system/core/api/api_json.dart';
import '../dashboard_service.dart';
import 'summary_card.dart';

class ProviderStatisticsModel {
  final List<SummaryCard> summaryCards;
  final List<ServiceDistribution> chart;
  ProviderStatisticsModel({required this.summaryCards, this.chart = const []});

  factory ProviderStatisticsModel.fromJson(Map<String, dynamic> json) {
    final data = ApiJson.object(json)['data'];
    if (data is! Map) {
      throw const FormatException('Invalid statistics response');
    }
    final object = ApiJson.object(data);
    final cards = object['summaryCards'];
    final chart = object['chart'];
    if (cards is! List || (chart != null && chart is! List)) {
      throw const FormatException('Invalid service statistics');
    }
    return ProviderStatisticsModel(
      summaryCards: cards
          .map((e) => SummaryCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      chart: (chart as List? ?? [])
          .map((e) => ServiceDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ServiceDistribution {
  const ServiceDistribution(
      {this.serviceId,
      this.serviceName,
      this.serviceLatinName,
      required this.percentage});
  final int? serviceId;
  final String? serviceName;
  final String? serviceLatinName;
  final double percentage;

  factory ServiceDistribution.fromJson(Map<String, dynamic> json) {
    final data = ApiJson.object(json);
    final percentage = dashboardNumber(data['percentage']);
    if (percentage == null || percentage < 0 || percentage > 100) {
      throw const FormatException('Invalid service percentage');
    }
    return ServiceDistribution(
      serviceId: DashboardService.resolve(
        id: dashboardInt(data['mainServiceId'] ?? data['serviceId']),
        arabic: data['serviceName']?.toString(),
        english: data['serviceLatinName']?.toString(),
      ),
      serviceName: data['serviceName']?.toString(),
      serviceLatinName: data['serviceLatinName']?.toString(),
      percentage: percentage,
    );
  }
}
