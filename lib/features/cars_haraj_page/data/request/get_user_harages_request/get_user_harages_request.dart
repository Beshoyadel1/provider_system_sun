class GetUserHaragesRequest {
  final int? branchId;
  final bool? includeSuspended;
  final int? pageSize;
  final int userId;
  final int userType;
  final int pageNumber;
  GetUserHaragesRequest({
    this.branchId, this.includeSuspended, this.pageSize,
    required this.userId,
    required this.userType,
    required this.pageNumber,

  });

  Map<String, dynamic> toJson() {
    return {
      if (branchId != null && branchId! > 0) 'branchId': branchId,
      if (includeSuspended != null) 'includeSuspended': includeSuspended,
      if (pageSize != null) 'pageSize': pageSize,
      "userId": userId,
      "userType": userType,
      "pageNumber": pageNumber,
    };
  }
}
