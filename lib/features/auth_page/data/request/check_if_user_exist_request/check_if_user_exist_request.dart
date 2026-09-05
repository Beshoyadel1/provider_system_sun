class CheckIfUserExistRequest {
  final String phone;
  final String email;
  final int type;

  CheckIfUserExistRequest({
    required this.phone,
    required this.email,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'type': type,
    };
  }
}
