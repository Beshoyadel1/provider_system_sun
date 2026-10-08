import '../../../auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import '../../../internal_services/data/model/get_provider_orders_model/order_model.dart';

class OrderEmployeeAssignment {
  OrderEmployeeAssignment({
    required this.providerId,
    required this.branchId,
    required Iterable<int> serviceIds,
  }) : serviceIds = serviceIds.where((id) => id > 0).toSet().toList()..sort();

  factory OrderEmployeeAssignment.fromOrder(
      OrderDetailsModel details, OrderModel order) {
    final detailIds = details.services
        ?.map((service) => service.id ?? 0)
        .where((id) => id > 0)
        .toList();
    return OrderEmployeeAssignment(
      providerId: details.provid ?? order.providerId,
      branchId: details.branchid ?? order.branchId,
      // Category IDs come from the order, never a sidebar category or a
      // provider's billed-service ID (provserviceid).
      serviceIds: detailIds?.isNotEmpty == true
          ? detailIds!
          : order.services?.map((service) => service.id ?? 0) ?? const [],
    );
  }

  final int? providerId;
  final int? branchId;
  final List<int> serviceIds;

  bool get isComplete =>
      (providerId ?? 0) > 0 && (branchId ?? 0) > 0 && serviceIds.isNotEmpty;

  List<CreateUserRequest> eligibleEmployees(List<CreateUserRequest> employees) {
    final seen = <int>{};
    return employees.where((employee) {
      final wrapper = employee.employeeDetails;
      final details = wrapper?.employeeDetails;
      final id = details?.id;
      return id != null &&
          id > 0 &&
          employee.isActive != false &&
          details?.provid == providerId &&
          details?.branchid == branchId &&
          serviceIds.any((id) => wrapper!.serviceIds.contains(id)) &&
          seen.add(id);
    }).toList(growable: false);
  }

  bool coversServices(Iterable<CreateUserRequest> selectedEmployees) {
    final covered = selectedEmployees
        .expand(
            (employee) => employee.employeeDetails?.serviceIds ?? const <int>[])
        .toSet();
    return serviceIds.isNotEmpty && serviceIds.every(covered.contains);
  }
}
