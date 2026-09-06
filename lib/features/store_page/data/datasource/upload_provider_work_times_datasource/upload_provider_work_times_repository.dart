import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sun_web_system/features/store_page/data/model/upload_provider_work_times_model/work_time_model.dart';
import 'package:sun_web_system/features/store_page/data/request/upload_provider_work_times_request/upload_provider_work_times_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<List<WorkTimeModel>> uploadProviderWorkTimesFunction({
  required UploadProviderWorkTimesRequest uploadProviderWorkTimesRequest,
}) async {
  try {
    final jsonString = json.encode(uploadProviderWorkTimesRequest.toJson());

    final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.uploadProviderWorkTimes,
    );

    final responseData = response.data;
    if (responseData is! Map) {
      throw Exception('Invalid server response');
    }

    final data = Map<String, dynamic>.from(responseData);
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Something went wrong');
    }

    return WorkTimeModel.fromJsonList(data['data']);
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
