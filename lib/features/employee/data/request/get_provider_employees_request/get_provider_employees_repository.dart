class GetProviderEmployeesRepository {
  final int provId;

  GetProviderEmployeesRepository({
    required this.provId,
  });

  Map<String, dynamic> toJson() {
    return {
      "provId": provId,
    };
  }
}