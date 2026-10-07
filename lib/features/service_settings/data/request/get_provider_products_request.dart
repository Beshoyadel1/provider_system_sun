class GetProviderProductsRequest {
  final int providerId;
  final int? categoryId;
  final int? branchId;

  const GetProviderProductsRequest({
    required this.providerId,
    this.categoryId,
    this.branchId,
  });

  Map<String, dynamic> toQuery() => {
        'providerId': providerId,
        if (categoryId != null) 'categoryId': categoryId,
        if (branchId != null && branchId! > 0) 'branchId': branchId,
      };
}
