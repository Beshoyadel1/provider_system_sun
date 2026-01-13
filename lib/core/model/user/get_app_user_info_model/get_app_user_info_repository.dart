import 'package:dio/dio.dart';
import '../../../../core/model/user/get_app_user_info_model/get_app_user_info_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> restoreUserFunction({
  required GetAppUserInfoRequest getAppUserInfoRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getAppUserInfoRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/Users/GetAppUserInfo",
    );
    AppSnackBar.showSuccess("Get App User Info successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
