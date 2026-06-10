import 'dart:convert';

import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/employee/data/request/get_provider_employees_request/get_provider_employees_repository.dart';

import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';

Future<List<CreateUserRequest>> getProviderEmployees({
  required GetProviderEmployeesRepository request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getProviderEmployees,
    );

    dynamic body;

    if (response.data is String) {
      body = jsonDecode(response.data);
    } else {
      body = response.data;
    }

    if (body is! Map<String, dynamic>) {
      throw Exception(
        'Invalid response format: ${body.runtimeType}',
      );
    }

    final List<dynamic> data =
        body['data'] as List<dynamic>? ?? [];

    final List<CreateUserRequest> employees = [];

    for (final item in data) {
      try {
        employees.add(
          CreateUserRequest.fromJson(
            Map<String, dynamic>.from(item),
          ),
        );
      } catch (e, s) {
        // print('================================');
        // print('FAILED ITEM => $item');
        // print('ERROR => $e');
        // print('STACK => $s');
        // print('================================');
      }
    }

  //  print('EMPLOYEES COUNT => ${employees.length}');

    return employees;
  } catch (e, s) {
    // print('API ERROR => $e');
    // print('STACK => $s');
    rethrow;
  }
}