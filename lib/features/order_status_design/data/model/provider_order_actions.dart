import '../../../../core/api/dio_function/api_constants.dart';

/// Actions performed by this provider, rather than by a customer or company.
class ProviderOrderActions {
  static List<int> allowed(int? status,
      {bool isDeliveryOrder = false, bool isOnSite = false}) {
    // Accepting/rejecting the provider's order is separate from courier progress.
    if (status == OrderStatus.newOrderForProvider) {
      return const [
        OrderStatus.waitingAppointment,
        OrderStatus.rejectedByProvider
      ];
    }
    // Later delivery stages are still received from the delivery integration.
    if (isDeliveryOrder) return const [];
    switch (status) {
      case OrderStatus.waitingAppointment:
        return [
          isOnSite ? OrderStatus.workInProgress : OrderStatus.employeeInRoad
        ];
      case OrderStatus.employeeInRoad:
        return const [OrderStatus.workInProgress];
      case OrderStatus.workInProgress:
        return const [OrderStatus.orderCompleted];
      default:
        return const [];
    }
  }
}
