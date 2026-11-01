import '../../../../../core/api/api_json.dart';

class OrderCoupon {
  const OrderCoupon({this.code, this.amount});
  final String? code;
  final num? amount;
  factory OrderCoupon.fromJson(Map raw) {
    final json = ApiJson.object(raw);
    return OrderCoupon(
        code: json['couponCode']?.toString(),
        amount: num.tryParse('${json['appliedCouponAmount']}'));
  }
  Map<String, dynamic> toJson() =>
      {'couponCode': code, 'appliedCouponAmount': amount};
}

class OrderPoints {
  const OrderPoints({this.points, this.amount});
  final num? points, amount;
  factory OrderPoints.fromJson(Map raw) {
    final json = ApiJson.object(raw);
    return OrderPoints(
        points: num.tryParse('${json['points']}'),
        amount: num.tryParse('${json['appliedPointsAmount']}'));
  }
  Map<String, dynamic> toJson() =>
      {'points': points, 'appliedPointsAmount': amount};
}
