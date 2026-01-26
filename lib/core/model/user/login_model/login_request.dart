class LoginRequest {
  final String user;
  final String password;

  LoginRequest({
    required this.user,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "USER": user,
      "PASSWORD": password,
    };
  }
}
