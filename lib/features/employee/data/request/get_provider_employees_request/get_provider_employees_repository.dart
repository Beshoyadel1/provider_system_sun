class GetProviderEmployeesRepository {
  final int provId;
  final int? branchId;

  GetProviderEmployeesRepository({
    required this.provId,
    this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {
      "provId": provId,
      if (branchId != null && branchId! > 0) 'branchId': branchId,
    };
  }
}
