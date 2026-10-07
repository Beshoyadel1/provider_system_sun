class UpdateOrderStatusRequest {
  final int orderId;
  final int status;
  final int changedById;
  final int changedByType;

  UpdateOrderStatusRequest({
    required this.orderId,
    required this.status,
    required this.changedById,
    required this.changedByType,
  });

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "status": status,
      "changedById": changedById,
      "changedByType": changedByType,
    };
  }
}
