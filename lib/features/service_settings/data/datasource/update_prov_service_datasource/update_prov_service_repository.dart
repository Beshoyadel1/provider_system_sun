import 'dart:convert';
import 'package:dio/dio.dart';
import '../../request/update_prov_service_request/update_prov_service_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<void> updateProvServiceFunction({
  required UpdateProvServiceRequest updateProvServiceRequest,
}) async {
  try {
    String jsonString = json.encode(updateProvServiceRequest.toJson());

    final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.updateProvService,
    );

    final body = response.data;
    if (body is! Map || body['success'] != true) {
      throw FormatException(
        body is Map
            ? body['message']?.toString() ??
                'Update service request was not successful'
            : 'Invalid update service response',
      );
    }
  } catch (e) {
    throw e is DioException
        ? responseOfStatusCode(e.response?.statusCode)
        : e.toString();
  }
}
