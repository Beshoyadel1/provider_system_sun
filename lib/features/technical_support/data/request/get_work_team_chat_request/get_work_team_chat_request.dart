class GetWorkTeamChatRequest {
  final int userId;
  int get user => userId;
  final int userType;

  GetWorkTeamChatRequest({
    int? userId,
    int? user,
    required this.userType,
  }) : userId = userId ?? user ?? 0;

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "user": userId,
      "userType": userType,
    };
  }
}