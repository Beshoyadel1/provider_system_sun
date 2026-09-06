import 'package:dio/dio.dart';
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
      {},
      getProviderWorkTimeRequest.toJson(),
      ApiLink.getProviderWorkTime,
    );

    final responseData = response.data;

    final bool success = responseData["success"] ?? false;

    /// 👇 لو مفيش بيانات
    if (!success) {
      return [];
    }

    return WorkTimeModel.fromJsonList(responseData["data"]);
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
