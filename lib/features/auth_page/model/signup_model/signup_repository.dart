import 'package:dio/dio.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../core/constants.dart';
import '../../../../features/auth_page/model/signup_model/signup_request.dart';

class SignupRepository {
  Future<void> signup(SignupRequest request) async {
    try {
      final response = await Network.dio.post(
        "/Users/RegisterUser",
        data: request.toJson(),
        options: Options(headers: myHeaders),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception("Signup failed");
      }
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
