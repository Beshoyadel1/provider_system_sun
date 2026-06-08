class GetEmployeesRequest {
  final int providerId;

  GetEmployeesRequest({
    required this.providerId,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
    };
  }
}