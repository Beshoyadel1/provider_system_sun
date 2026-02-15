import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/language/language_constant.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/api_functions/user/login_model/login_request.dart';
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
    final body = value.data.toString().trim();
    if (body == "Wrong Password") {
      AppSnackBar.showError(
        AppLanguageKeys.wrongPasswordKey,
      );
      return false;
    }
    if (body == "No User") {
      AppSnackBar.showError(
        AppLanguageKeys.wrongUsername,
      );
      return false;
    }
    AppSnackBar.showSuccess(
      AppLanguageKeys.accountLoginSuccessfully,
    );
    return true;

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
    return false;
  }
}
