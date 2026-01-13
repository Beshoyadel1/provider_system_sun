class LoginResponse {
  final bool success;
  final String message;
  final dynamic data;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"] ?? true,
      message: json["message"] ?? "Login Success",
      data: json["data"],
    );
  }
}
