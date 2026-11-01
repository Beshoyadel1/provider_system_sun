import 'package:dio/dio.dart';
import '../../../../../core/api/api_result.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/api/dio_function/dio_controller.dart';
import 'package:sun_web_system/core/api/dio_function/failures.dart';
import 'package:sun_web_system/features/store_page/data/request/save_provider_work_time_request/provider_work_time_request.dart';

Future<void> createProviderWorkTimeFunction({
  required ProviderWorkTimeRequest request,
}) {
  return _saveProviderWorkTime(
    request: request,
    endpoint: ApiLink.createProviderWorkTime,
  );
}

Future<void> updateProviderWorkTimeFunction({
  required ProviderWorkTimeRequest request,
}) {
  return _saveProviderWorkTime(
    request: request,
    endpoint: ApiLink.updateProviderWorkTime,
  );
}

Future<void> _saveProviderWorkTime({
  required ProviderWorkTimeRequest request,
  required String endpoint,
}) async {
  try {
    final response = await Network.postDataWithBody(request.toJson(), endpoint);
    ApiResult.requireSuccess(response);
  } catch (error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        throw Exception(
          data['message'] ?? responseOfStatusCode(error.response?.statusCode),
        );
      }
      throw Exception(responseOfStatusCode(error.response?.statusCode));
    }
    rethrow;
  }
}
