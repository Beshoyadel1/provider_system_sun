class GetProviderTotalRateAndEmployeeAndBalanceRequest {
  final int providerId;
  final int? branchId;

  GetProviderTotalRateAndEmployeeAndBalanceRequest({
    required this.providerId,
    this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      if (branchId != null && branchId! > 0) 'branchId': branchId,
    };
  }
}
