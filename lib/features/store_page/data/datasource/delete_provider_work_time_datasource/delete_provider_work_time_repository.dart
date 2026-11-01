import 'package:dio/dio.dart';
import '../../../../../core/api/api_result.dart';
import 'package:sun_web_system/features/store_page/data/request/delete_provider_work_time_request/delete_provider_work_time_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<void> deleteProviderWorkTimeFunction({
  required DeleteProviderWorkTimeRequest deleteProviderWorkTimeRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      null,
      deleteProviderWorkTimeRequest.toJson(),
      ApiLink.deleteProviderWorkTime,
    );

    ApiResult.requireSuccess(response);
  } catch (e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        throw Exception(
            data['message'] ?? responseOfStatusCode(e.response?.statusCode));
      }
      throw Exception(responseOfStatusCode(e.response?.statusCode));
    }
    rethrow;
  }
}
