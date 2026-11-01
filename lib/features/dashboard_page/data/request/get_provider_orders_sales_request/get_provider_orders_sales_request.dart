class GetProviderOrdersSalesRequest {
  final int providerId;
  final int? branchId;
  final String? startDate;
  final String? endDate;

  GetProviderOrdersSalesRequest({
    required this.providerId,
    this.branchId,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      if (branchId != null && branchId! > 0) 'branchId': branchId,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };
  }
}
