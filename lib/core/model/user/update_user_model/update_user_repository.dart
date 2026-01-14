import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/user/update_user_model/update_user_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> updateUserFunction({required UpdateUserRequest updateUserRequest}) async {
  try {
    String jsonString = json.encode(updateUserRequest.toJson());
    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.user}/UpdateUser",
    ).then((value) {
      AppSnackBar.showSuccess("Update User successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}

