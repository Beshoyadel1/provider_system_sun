class ServiceOfferRequest {
  const ServiceOfferRequest({
    this.id,
    required this.serviceRequestId,
    required this.providerId,
    required this.branchId,
    required this.price,
    required this.cost,
    required this.serviceId,
    required this.taxId,
    required this.employeeId,
    required this.providerServiceId,
  });

  final int? id;
  final int serviceRequestId;
  final int providerId;
  final int branchId;
  final double price;
  final double cost;
  final int serviceId;
  final int taxId;
  final int employeeId;
  final int providerServiceId;

  Map<String, dynamic> toCreateJson() => {
        'servicerequestid': serviceRequestId,
        'provid': providerId,
        'branchid': branchId,
        'price': price,
        'cost': cost,
        'serviceid': serviceId,
        'taxid': taxId,
        'employeeid': employeeId,
        'provserviceid': providerServiceId,
      };

  Map<String, dynamic> toUpdateJson() => {
        'id': id,
        'price': price,
        'cost': cost,
        'branchid': branchId,
        'serviceid': serviceId,
        'taxid': taxId,
        'employeeid': employeeId,
        'provserviceid': providerServiceId,
      };
}
