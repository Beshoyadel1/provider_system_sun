import 'package:dio/dio.dart';
import 'package:sun_web_system/core/model/user/check_if_user_exist_or_not_model/check_if_user_exist_or_not_request.dart';
import '../../../../core/model/user/restore_user_model/restore_user_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> checkIfUserExistOrNotFunction({
  required CheckIfUserExistOrNotRequest checkIfUserExistOrNotRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      checkIfUserExistOrNotRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.user}/CheckIfUserExistOrNot",
    );
    AppSnackBar.showSuccess("Check If User Exist Or Not successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
