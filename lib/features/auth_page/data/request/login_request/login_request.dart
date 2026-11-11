class LoginRequest {
  final String user;
  final String password;
  final int type;
  final String? fcmToken;

  LoginRequest({
    required this.user,
    required this.password,
    required this.type,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    final token = fcmToken?.trim();
    return {
      "USER": user,
      "PASSWORD": password,
      "TYPE": type,
      "FCMTOKEN": token ?? '',
    };
  }
}
