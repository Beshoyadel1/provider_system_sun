import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/language/language_constant.dart';
import '../../../../core/api_functions/user/change_password_model/change_password_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> changePasswordFunction({required ChangePasswordRequest changePasswordRequest}) async {
  try {
    String jsonString = json.encode(changePasswordRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      ApiLink.changePassword,
    ).then((value) {
      AppSnackBar.showSuccess(AppLanguageKeys.changePasswordSuccessfully);
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}

