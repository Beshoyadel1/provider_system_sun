class GetProviderHarageMonthlySalesRequest {
  final int providerId;
  final int branchId;

  GetProviderHarageMonthlySalesRequest({
    required this.providerId,
    required this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      "branchId": branchId,
    };
  }
}