import '../../../../../core/api/api_json.dart';

class DeliveryOrderModel {
  DeliveryOrderModel(
      {this.orderId,
      this.providerId,
      this.deliveryOrderId,
      this.status,
      this.courierName,
      this.courierPhone,
      this.fee,
      this.acceptedAt,
      this.receivedAt,
      this.deliveredAt});

  final int? orderId, providerId, deliveryOrderId;
  final String? status, courierName, courierPhone;
  final num? fee;
  final DateTime? acceptedAt, receivedAt, deliveredAt;

  static String? normalizeStatus(Object? value) {
    final text = value?.toString().trim();
    switch (text?.toLowerCase().replaceAll('_', '')) {
      case 'new':
      case 'neworder':
        return 'new';
      case 'accepted':
        return 'accepted';
      case 'arrivedtostore':
        return 'arrived_to_store';
      case 'picked':
      case 'received':
        return 'picked';
      case 'delivered':
        return 'delivered';
      case 'cancelled':
        return 'cancelled';
      default:
        return text?.isEmpty == false ? text : null;
    }
  }

  factory DeliveryOrderModel.fromJson(Map raw) {
    final json = ApiJson.object(raw);
    int? integer(String key) => int.tryParse('${json[key]}');
    DateTime? date(String key) => DateTime.tryParse('${json[key]}');
    return DeliveryOrderModel(
      orderId: integer('orderId'),
      providerId: integer('provid'),
      deliveryOrderId: integer('deliveryOrderId'),
      status: normalizeStatus(json['deliveryOrderStatus']),
      courierName: json['mandoobName']?.toString(),
      courierPhone: json['mandoobPhone']?.toString(),
      fee: num.tryParse('${json['deliveryFee']}'),
      acceptedAt: date('mandoobAcceptOrderDate'),
      receivedAt: date('mandoobReceiveOrderDate'),
      deliveredAt: date('mandoobDeliverOrderDate'),
    );
  }

  DeliveryOrderModel applyPatch(Map patch) => DeliveryOrderModel.fromJson({
        ...toJson(),
        ...ApiJson.object(patch),
      });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'provid': providerId,
        'deliveryOrderId': deliveryOrderId,
        'deliveryOrderStatus': status,
        'mandoobName': courierName,
        'mandoobPhone': courierPhone,
        'deliveryFee': fee,
        'mandoobAcceptOrderDate': acceptedAt?.toIso8601String(),
        'mandoobReceiveOrderDate': receivedAt?.toIso8601String(),
        'mandoobDeliverOrderDate': deliveredAt?.toIso8601String(),
      };
}
