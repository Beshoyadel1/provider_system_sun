import 'package:dio/dio.dart';

import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_emp_request.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/employee/data/request/get_branch_employees_request/get_branch_employees_request.dart';

import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<List<CreateUserRequest>>
getBranchEmployeesFunction({
  required GetBranchEmployeesRequest
  getBranchEmployeesRequest,
}) async {
  try {
    final response =
    await Network.getDataWithBodyAndParams(
      {},
      getBranchEmployeesRequest.toJson(),
      ApiLink.getBranchEmployees,
    );

    final responseData = response.data;

    final bool success =
        responseData["success"] ?? false;

    if (!success) {
      throw Exception(
        responseData["message"] ??
            "Something went wrong",
      );
    }

    final List<dynamic> data =
        responseData["data"] ?? [];

    return data
        .map(
          (e) => CreateUserRequest.fromJson(
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  } catch (e) {
    if (e is DioException) {
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
    }

    throw Exception(e.toString());
  }
}