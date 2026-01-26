import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/user/create_user_model/create_user_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<bool> createUserFunction({required CreateUserRequest createUserRequest}) async {
  try {
    String jsonString = json.encode(createUserRequest.toJson());

    final value = await Network.postDataWithBody(
      jsonString,
        ApiLink.createUser
    );

    print("Raw Response: ${value.data}");

    // CASE 1: Plain text success → "Done"
    if (value.data is String && value.data.toString().trim() == "Done") {
      print("✅ Create User Success: Done");
      AppSnackBar.showSuccess("Account created successfully");
      return true;
    }

    // Now try JSON decode only if it looks like JSON
    final decoded =
    value.data is String ? json.decode(value.data) : value.data;

    // CASE 2: Map with message
    if (decoded is Map && decoded.containsKey("message")) {
      String message = decoded["message"].toString();

      if (message.toLowerCase() == "done") {
        print("✅ Create User Success: $message");
        AppSnackBar.showSuccess("Account created successfully");
        return true;
      } else {
        print("❌ Create User Error: $message");
        AppSnackBar.showError(message);
        return false;
      }
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
