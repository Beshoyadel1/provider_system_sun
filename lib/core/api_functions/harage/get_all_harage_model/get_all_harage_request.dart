class GetAllHarageRequest {
  final int providerId;

  GetAllHarageRequest({
    required this.providerId,
  });

  Map<String, dynamic> toJson() {
    return {
      "ProviderId": providerId,
    };
  }
}