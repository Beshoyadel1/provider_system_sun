class ChangePasswordRequest {
  final String user;
  final String password;
  final int type;

  ChangePasswordRequest({
    required this.user,
    required this.password,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "USER": user,
      "PASSWORD": password,
      "TYPE": type,
    };
  }
}
