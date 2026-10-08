class UpdateOrderStatusRequest {
  final int orderId;
  final int status;
  final int changedById;
  final int changedByType;
  final List<int> employeeIds;

  UpdateOrderStatusRequest({
    required this.orderId,
    required this.status,
    required this.changedById,
    required this.changedByType,
    List<int> employeeIds = const [],
  }) : employeeIds = List.unmodifiable(employeeIds.toSet().toList()..sort());

  Map<String, dynamic> toJson() {
    return {
      "orderId": orderId,
      "status": status,
      "changedById": changedById,
      "changedByType": changedByType,
      if (employeeIds.isNotEmpty) "employeeIds": employeeIds.join(','),
    };
  }
}
