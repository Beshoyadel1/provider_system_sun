import 'dart:convert';
import 'package:dio/dio.dart';
import '../../request/create_prov_service_request/create_prov_service_request.dart';
import '../../response/create_prov_service_response/create_prov_service_response.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

class CreateProvServiceRepository {
  Future<CreateProvServiceResponse> createProvService({
    required CreateProvServiceRequest request,
  }) async {
    try {
      String jsonString = json.encode(request.toJson());

      final response = await Network.postDataWithBody(
        jsonString,
        ApiLink.createProvService,
      );

      final body = response.data;
      if (body is! Map || body['success'] != true) {
        throw FormatException(
          body is Map
              ? body['message']?.toString() ??
                  'Create service request was not successful'
              : 'Invalid create service response',
        );
      }

      final data = body['data'];
      if (data is! Map) {
        throw const FormatException('Invalid create service response');
      }

      return CreateProvServiceResponse.fromJson(
        Map<String, dynamic>.from(data),
      );
    } catch (e) {
      throw e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString();
    }
  }
}
