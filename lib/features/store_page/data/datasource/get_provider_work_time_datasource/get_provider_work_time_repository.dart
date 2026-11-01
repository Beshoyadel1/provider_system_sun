import 'package:dio/dio.dart';
import '../../../../../core/api/api_result.dart';
import '../../../../../features/store_page/data/request/get_provider_work_time_request/get_provider_work_time_request.dart';
import '../../../../../features/store_page/data/model/upload_provider_work_times_model/work_time_model.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<List<WorkTimeModel>> getProviderWorkTimeFunction({
  required GetProviderWorkTimeRequest getProviderWorkTimeRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      null,
      getProviderWorkTimeRequest.toJson(),
      ApiLink.getProviderWorkTime,
    );

    final body = ApiResult.requireSuccess(response);
    final data = body['data'];
    if (data is! List || data.any((item) => item is! Map)) {
      throw const FormatException('Invalid work times response');
    }
    final times = WorkTimeModel.fromJsonList(data);
    if (times
        .any((time) => time.provid != getProviderWorkTimeRequest.providerId)) {
      throw const FormatException('Work times do not belong to this provider');
    }
    return times;
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

    throw Exception(
      e.toString(),
    );
  }
}
