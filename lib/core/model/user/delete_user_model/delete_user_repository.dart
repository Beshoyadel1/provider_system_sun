import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/user/delete_user_model/delete_user_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> deleteUserFunction({
  required DeleteUserRequest deleteUserRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteUserRequest.toJson(), // params
      ApiLink.deleteUser,
    );
    AppSnackBar.showSuccess("Delete User successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
