class CheckIfUserExistRequest {
  final String phone;
  final String type;

  CheckIfUserExistRequest({
    required this.phone,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "type": type,
    };
  }
}
