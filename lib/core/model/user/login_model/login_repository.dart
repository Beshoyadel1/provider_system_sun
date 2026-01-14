import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/model/user/login_model/login_request.dart';
import '../../../../core/model/user/login_model/login_response.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


class LoginRepository {
  Future<void> loginFunction({required LoginRequest loginRequest}) async {
    try {
      String jsonString = json.encode(loginRequest.toJson());

      final response = await Network.postDataWithBody(
        jsonString,
        "${ApiConfig.baseUrlApi}/${ApiConfig.user}/LogInUser",
      );
      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      AppSnackBar.showSuccess("Login Success");
      print(loginResponse);
    } catch (e) {
      AppSnackBar.showError(
        e is DioException
            ? responseOfStatusCode(e.response?.statusCode)
            : e.toString(),
      );
    }
  }

}
