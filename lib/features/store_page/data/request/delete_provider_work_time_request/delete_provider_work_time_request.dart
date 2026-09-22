class DeleteProviderWorkTimeRequest {
  final int workTimeId;

  DeleteProviderWorkTimeRequest({
    required this.workTimeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "workTimeId": workTimeId,
    };
  }
}
