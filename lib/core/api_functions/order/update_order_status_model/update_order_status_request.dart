class UpdateOrderStatusRequest {
  final int orderId;
  final int status;
  final int driverId;

  UpdateOrderStatusRequest({
    required this.orderId,
    required this.status,
    required this.driverId,
  });

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "status": status,
      "driverId": driverId,
    };
  }
}