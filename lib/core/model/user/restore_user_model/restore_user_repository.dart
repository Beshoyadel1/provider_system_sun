import 'package:dio/dio.dart';
import '../../../../core/model/user/restore_user_model/restore_user_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> restoreUserFunction({
  required RestoreUserRequest restoreUserRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      restoreUserRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.user}/RestoreUser",
    );
    AppSnackBar.showSuccess("Restore User successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
