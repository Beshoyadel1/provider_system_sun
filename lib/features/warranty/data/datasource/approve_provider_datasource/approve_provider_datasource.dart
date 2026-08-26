import 'package:dio/dio.dart';
import 'package:sun_web_system/features/warranty/data/request/approve_provider_request/approve_provider_request.dart';

import '../../../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../../../../core/api/dio_function/failures.dart';


Future<bool> approveProviderFunction({
  required ApproveProviderRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.approveProvider,
    );

    final responseData = response.data;

    final bool success =
        responseData['success'] ?? false;

    if (!success) {
      throw Exception(
        responseData['message'] ??
            'Something went wrong',
      );
    }

    return true;
  } on DioException catch (e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      throw Exception(
        data['message'] ??
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
  } catch (e) {
    throw Exception(
      e.toString(),
    );
  }
}