import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/language/language_constant.dart';
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
    if (value.data is String && value.data.toString().trim() == "Done") {
      AppSnackBar.showSuccess(AppLanguageKeys.accountCreatedSuccessfully);
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