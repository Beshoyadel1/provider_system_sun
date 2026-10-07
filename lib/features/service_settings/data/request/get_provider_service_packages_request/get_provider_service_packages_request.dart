class GetProviderServicePackagesRequest {
  final int? branchId;
  final int providerId;

  GetProviderServicePackagesRequest({
    this.branchId,
    required this.providerId,
  });

  Map<String, dynamic> toJson() {
    return {
      if (branchId != null && branchId! > 0) "branchId": branchId,
      "providerId": providerId,
    };
  }
}
