import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/user/create_user_model/create_user_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> createUserFunction({required CreateUserRequest createUserRequest}) async {
  try {
    String jsonString = json.encode(createUserRequest.toJson());

    await Network.postDataWithBody(
      jsonString,
      "${ApiConfig.baseUrlApi}/${ApiConfig.user}/RegisterUser",
    ).then((value) {
      AppSnackBar.showSuccess("Account created successfully");
    });

  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}

