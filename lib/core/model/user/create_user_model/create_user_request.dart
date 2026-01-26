class CreateUserRequest {
  final String username;
  final String phone;
  final String email;
  final String password;

  CreateUserRequest({
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "phone": phone,
      "email": email,
      "password": password,
    };
  }
}
