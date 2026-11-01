import 'package:sun_web_system/core/api/api_json.dart';
import '../dashboard_service.dart';

class SummaryCard {
  final int? serviceId;
  final String? serviceName;
  final String? serviceLatinName;
  final int? orderCount;
  final double? totalAmount;
  final double? percentageChange;
  final bool? isIncrease;

  SummaryCard({
    this.serviceId,
    this.serviceName,
    this.serviceLatinName,
    this.orderCount,
    this.totalAmount,
    this.percentageChange,
    this.isIncrease,
  });

  factory SummaryCard.fromJson(Map<String, dynamic> json) {
    json = ApiJson.object(json);
    return SummaryCard(
      serviceId: dashboardInt(json['mainServiceId'] ?? json['serviceId']),
      serviceName: json['serviceName']?.toString(),
      serviceLatinName: json['serviceLatinName']?.toString(),
      orderCount: dashboardInt(json['orderCount']),
      totalAmount: dashboardNumber(json['totalAmount']),
      percentageChange: dashboardNumber(json['percentageChange']),
      isIncrease: json['isIncrease'],
    );
  }

  int? get resolvedServiceId => DashboardService.resolve(
      id: serviceId, arabic: serviceName, english: serviceLatinName);

  String getName(bool isArabic) {
    return isArabic ? (serviceName ?? '') : (serviceLatinName ?? '');
  }
}
