import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../core/api/api_json.dart';
import '../../model/login_model/user_response_reader.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../features/auth_page/data/model/login_model/login_result.dart';
import '../../request/login_request/login_request.dart';

Future<LoginResult> loginFunction({
  required LoginRequest loginRequest,
}) async {
  try {
    if (loginRequest.type != UserType.providerUser) {
      return LoginResult(success: false, message: AppLanguageKeys.loginFailed);
    }
    final payload = loginRequest.toJson();
    final response = await Network.postDataWithBody(
      json.encode(payload),
      ApiLink.loginUser,
    );

    if (response.data is! Map) {
      return LoginResult(
          success: false, message: AppLanguageKeys.invalidUserInformation);
    }
    final body = ApiJson.object(response.data);

    final bool success = (response.statusCode ?? 500) < 400 &&
        body['success'] == true &&
        body['status'] != false;

    final String message = body["message"]?.toString() ??
        (success
            ? AppLanguageKeys.accountLoginSuccessfully
            : AppLanguageKeys.loginFailed);

    if (!success) {
      return LoginResult(
        success: false,
        message: message,
      );
    }

    final user = UserResponseReader.read(body['data'],
        expectedType: UserType.providerUser);

    return LoginResult(
      success: true,
      message: message,
      user: user,
    );
  } on DioException catch (e) {
    String errorMessage = AppLanguageKeys.somethingWentWrong;

    if (e.response?.data != null) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        errorMessage = data["message"] ??
            responseOfStatusCode(
              e.response?.statusCode,
            );
      }
    }

    return LoginResult(
      success: false,
      message: errorMessage,
    );
  } on FormatException {
    return LoginResult(
        success: false, message: AppLanguageKeys.invalidUserInformation);
  } catch (e) {
    return LoginResult(
      success: false,
      message: e.toString(),
    );
  }
}
