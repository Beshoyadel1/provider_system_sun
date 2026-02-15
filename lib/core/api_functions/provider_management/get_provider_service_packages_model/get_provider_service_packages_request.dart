class GetProviderServicePackagesRequest {
  final int provServiceId;

  GetProviderServicePackagesRequest({
    required this.provServiceId,
  });

  Map<String, dynamic> toJson() {
    return {
      "provServiceId": provServiceId,
    };
  }
}