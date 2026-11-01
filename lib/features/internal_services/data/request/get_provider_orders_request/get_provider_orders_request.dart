class GetProviderOrdersRequest {
  final int? providerId;
  final int? employeeId;
  final int? pageNumber;
  final int? orderType;
  final int? serviceId;
  final int? branchId;
  final int? pageSize;

  GetProviderOrdersRequest(
      {this.providerId,
      this.employeeId,
      this.pageNumber,
      this.orderType,
      this.serviceId,
      this.branchId, this.pageSize});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "providerId": providerId,
      "employeeId": employeeId,
      "pageNumber": pageNumber,
      "orderType": orderType,
      "ServiceId": serviceId,
      "branchId": branchId,
      'pageSize': pageSize,
    }..removeWhere((_, value) => value == null);
  }
}
