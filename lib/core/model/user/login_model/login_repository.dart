import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/model/user/login_model/login_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';


Future<bool> loginFunction({required LoginRequest loginRequest}) async {
  try {
    String jsonString = json.encode(loginRequest.toJson());

    final value = await Network.postDataWithBody(
      jsonString,
      ApiFunction.loginUser,
    );

    final decoded =
    value.data is String ? json.decode(value.data) : value.data;

    // Error case
    if (decoded is Map && decoded.containsKey("message")) {
      String message = decoded["message"].toString();
      print("❌ Login Error: $message");
      AppSnackBar.showError(message);
      return false;
    }

    // Success case → navigate after this
    if (decoded is List && decoded.isNotEmpty) {
      print("✅ Login Success");
      print("User Data: ${decoded[0]}");
      AppSnackBar.showSuccess("Account Login successfully");
      return true;
    }

    AppSnackBar.showError("Unexpected response from server");
    return false;

  } catch (e) {
    print("🔥 Exception Error: $e");
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
    return false;
  }
}
