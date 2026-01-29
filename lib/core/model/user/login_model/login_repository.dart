import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/language/language_constant.dart';
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
      ApiLink.loginUser,
    );

    dynamic decoded;
    // If response is String and starts like JSON → decode it
    if (value.data is String) {
      String responseText = value.data.toString().trim();

      // Case: backend returns "Wrong Password"
      if (!responseText.startsWith("{") && !responseText.startsWith("[")) {
        AppSnackBar.showError(responseText);
        return false;
      }

      decoded = json.decode(responseText);
    } else {
      decoded = value.data;
    }

    // Error message from backend (JSON)
    if (decoded is Map && decoded.containsKey("message")) {
      String message = decoded["message"].toString();
      AppSnackBar.showError(message);
      return false;
    }

    // Success case
    if (decoded is List && decoded.isNotEmpty) {
      AppSnackBar.showSuccess(AppLanguageKeys.accountLoginSuccessfully);
      return true;
    }

    return false;
  } on DioException catch (e) {
    AppSnackBar.showError(
      responseOfStatusCode(e.response?.statusCode),
    );
    return false;
  } catch (e) {
    AppSnackBar.showError(e.toString());
    return false;
  }
}
