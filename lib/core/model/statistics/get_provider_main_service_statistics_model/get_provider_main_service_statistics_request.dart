class GetProviderMainServiceStatisticsRequest {
  final int providerId;
  final int mainServiceId;
  final String startDate;
  final String endDate;
  final int branchId;

  GetProviderMainServiceStatisticsRequest({
    required this.providerId,
    required this.mainServiceId,
    required this.startDate,
    required this.endDate,
    required this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      "mainServiceId": mainServiceId,
      "startDate": startDate,
      "endDate": endDate,
      "branchId": branchId,
    };
  }
}