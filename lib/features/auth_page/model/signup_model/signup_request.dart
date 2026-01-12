class SignupRequest {
  final String username;
  final String phone;
  final String email;
  final String password;
  final int type;

  SignupRequest({
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "USERNAME": username,
      "PHONE": phone,
      "EMAIL": email,
      "PASSWORD": password,
      "TYPE": type,
    };
  }
}
