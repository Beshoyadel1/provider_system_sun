import 'package:dio/dio.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/constants.dart';
import '../../../../features/auth_page/model/login_model/login_request.dart';
import '../../../../features/auth_page/model/login_model/login_response.dart';

class LoginRepository {
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await Network.dio.post(
        "/Users/LogInUser",
        data: request.toJson(),
        options: Options(headers: myHeaders),
      );

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage;
      if (e.response != null) {
        errorMessage = responseOfStatusCode(e.response?.statusCode);
      } else {
        errorMessage = "No Internet Connection or Server not responding";
      }
      throw Exception(errorMessage);
    }
  }
}
