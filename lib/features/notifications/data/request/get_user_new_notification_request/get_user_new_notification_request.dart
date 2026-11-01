class GetUserNewNotificationRequest {
  final int userId;
  final int userType;
  final int? pageSize, pageNumber;
  GetUserNewNotificationRequest(
      {required this.userId,
      required this.userType,
      this.pageNumber,
      this.pageSize});

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userType": userType,
      if (pageNumber != null) "pageNumber": pageNumber,
      if (pageSize != null) "pageSize": pageSize,
    };
  }
}
