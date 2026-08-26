class ApproveProviderRequest {
  final int providerId;
  final int approvalId;

  const ApproveProviderRequest({
    required this.providerId,
    required this.approvalId,
  });

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
      'approvalId': approvalId,
    };
  }
}