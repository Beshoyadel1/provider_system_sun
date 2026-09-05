import 'package:dio/dio.dart';
import 'package:sun_web_system/features/auth_page/data/request/check_if_user_exist_request/check_if_user_exist_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/language/language_constant.dart';

class CheckIfUserExistResult {
  const CheckIfUserExistResult({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;
}

Future<CheckIfUserExistResult> checkIfUserExistFunction({
  required CheckIfUserExistRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.checkIfUserExist,
    );

    final data = response.data;
    if (data is Map) {
      return CheckIfUserExistResult(
        success: data['success'] == true,
        message: data['message']?.toString() ?? '',
      );
    }

    return const CheckIfUserExistResult(
      success: false,
      message: AppLanguageKeys.somethingWentWrong,
    );
  } catch (e) {
    final responseData = e is DioException ? e.response?.data : null;
    final backendMessage =
        responseData is Map ? responseData['message']?.toString() : null;

    return CheckIfUserExistResult(
      success: false,
      message: backendMessage?.trim().isNotEmpty == true
          ? backendMessage!
          : e is DioException
              ? responseOfStatusCode(e.response?.statusCode)
              : e.toString(),
    );
  }
}
