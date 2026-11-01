import 'package:dio/dio.dart';
import '../../../../../core/api/api_result.dart';
import '../../model/login_model/user_response_reader.dart';
import '../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../../core/api/dio_function/failures.dart';
import '../../../../../../../features/auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../../../../../features/auth_page/data/request/get_user_inf_request/get_user_info_datasource.dart';

Future<CreateUserRequest> getUserInfoFunction({
  required GetUserInfoRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      null,
      request.toJson(),
      ApiLink.getUserInfo,
    );

    final body = ApiResult.requireSuccess(response);
    return UserResponseReader.read(body['data'],
        expectedType: request.userType, expectedUserId: request.userId);
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      throw Exception(
        data["message"] ??
            responseOfStatusCode(
              e.response?.statusCode,
            ),
      );
    }

    throw Exception(
      responseOfStatusCode(
        e.response?.statusCode,
      ),
    );
  } catch (e) {
    throw Exception(
      e.toString(),
    );
  }
}
