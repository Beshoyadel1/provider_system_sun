import 'package:dio/dio.dart';

import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../auth_page/data/model/create_user_model/create_user_request.dart';

typedef ProviderServiceEmployeesLoader = Future<List<CreateUserRequest>>
    Function({
  required int providerId,
  required int branchId,
  required List<int> serviceIds,
});

Future<List<CreateUserRequest>> getProviderEmployeesByServices({
  required int providerId,
  required int branchId,
  required List<int> serviceIds,
}) async {
  final ids = serviceIds.where((id) => id > 0).toSet().toList()..sort();
  if (providerId <= 0 || branchId <= 0 || ids.isEmpty) {
    throw Exception('The order provider, branch and services are required');
  }
  try {
    final response = await Network.postDataWithBody({
      'providerId': providerId,
      'serviceIds': ids,
      'branchId': branchId,
    }, ApiLink.getProviderEmployeesByServices);
    final body = response.data;
    if ((response.statusCode ?? 500) >= 400 ||
        body is! Map ||
        body['success'] != true) {
      throw Exception(body is Map
          ? body['message'] ?? 'Could not load employees'
          : 'Invalid employees response');
    }
    final data = body['data'];
    if (data is! List) throw Exception('Invalid employees response');
    return data
        .map((item) =>
            CreateUserRequest.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList(growable: false);
  } on DioException catch (error) {
    final body = error.response?.data;
    throw Exception(body is Map
        ? body['message'] ?? 'Could not load employees'
        : error.message ?? 'Could not load employees');
  }
}
