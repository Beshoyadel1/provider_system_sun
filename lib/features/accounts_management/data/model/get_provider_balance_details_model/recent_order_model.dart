import 'package:sun_web_system/core/api/api_json.dart';
class RecentOrderModel {
  final int orderId;
  final double totalAmount;
  final DateTime date;
  final int status;

  RecentOrderModel({
    required this.orderId,
    required this.totalAmount,
    required this.date,
    required this.status,
  });

  factory RecentOrderModel.fromJson(Map<String, dynamic> json) {
    json = ApiJson.object(json);
    return RecentOrderModel(
      orderId: json['orderId'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'] ?? 0,
    );
  }
}
