import 'dart:convert';
import 'package:dio/dio.dart';
import '../../model/create_user_model/create_user_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';


class CreateUserResult {

  final bool success;
  final String message;

  CreateUserResult({
    required this.success,
    required this.message,
  });
}

Future<CreateUserResult> createUserFunction({
  required CreateUserRequest createUserRequest,
}) async {
  try {
    final jsonString = json.encode(
      createUserRequest.toJson(),
    );

    print('REQUEST => $jsonString');

    final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.createUser,
    );

    print('STATUS => ${response.statusCode}');
    print('RESPONSE => ${response.data}');

    final Map<String, dynamic> body =
    Map<String, dynamic>.from(response.data);

    return CreateUserResult(
      success: body["success"] == true,
      message: body["message"]?.toString() ?? "",
    );
  } on DioException catch (e) {
    print('DIO STATUS => ${e.response?.statusCode}');
    print('DIO RESPONSE => ${e.response?.data}');

    String errorMessage = "حدث خطأ ما";

    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      errorMessage =
          data["message"]?.toString() ??
              responseOfStatusCode(
                e.response?.statusCode,
              );
    }

    return CreateUserResult(
      success: false,
      message: errorMessage,
    );
  } catch (e, s) {
    print('ERROR => $e');
    print('STACK => $s');

    return CreateUserResult(
      success: false,
      message: e.toString(),
    );
  }
}