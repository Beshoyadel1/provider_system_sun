class GetProviderOrdersRequest {
  final int? providerId;
  final int? employeeId;
  final int? pageNumber;
  final int? orderType;
  final int? serviceId;

  GetProviderOrdersRequest({
    required this.providerId,
    required this.employeeId,
    required this.pageNumber,
    required this.orderType,
    required this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      "employeeId": employeeId,
      "pageNumber": pageNumber,
      "orderType": orderType,
      "ServiceId": serviceId,
    };
  }
}