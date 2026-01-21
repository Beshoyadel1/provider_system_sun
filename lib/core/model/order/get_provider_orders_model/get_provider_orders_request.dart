class GetProviderOrdersRequest {
  final int providerId;

  GetProviderOrdersRequest({
    required this.providerId,
  });

  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
    };
  }
}