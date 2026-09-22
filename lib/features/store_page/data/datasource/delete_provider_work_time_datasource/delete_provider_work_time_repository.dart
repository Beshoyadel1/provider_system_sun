import 'package:dio/dio.dart';
import 'package:sun_web_system/features/store_page/data/request/delete_provider_work_time_request/delete_provider_work_time_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<void> deleteProviderWorkTimeFunction({
  required DeleteProviderWorkTimeRequest deleteProviderWorkTimeRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      deleteProviderWorkTimeRequest.toJson(),
      ApiLink.deleteProviderWorkTime,
    );

    final responseData = response.data;
    if (responseData is! Map) {
      throw Exception('Invalid server response');
    }

    final data = Map<String, dynamic>.from(responseData);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Something went wrong');
    }
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
