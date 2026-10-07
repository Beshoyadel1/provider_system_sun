class GetProvServicesRequest {
  final int? branchId;
  final int providerId;
  final int serviceId;

  GetProvServicesRequest({
    this.branchId,
    required this.providerId,
    required this.serviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (branchId != null && branchId! > 0) "branchId": branchId,
      "providerId": providerId,
      "serviceId": serviceId,
    };
  }
}
