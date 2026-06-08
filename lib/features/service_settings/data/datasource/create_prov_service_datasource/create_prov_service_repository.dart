import 'dart:convert';
import 'package:dio/dio.dart';
import '../../request/create_prov_service_request/create_prov_service_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

class CreateProvServiceRepository {
  Future<void> createProvService({
    required CreateProvServiceRequest request,
  }) async {
    try {
      String jsonString = json.encode(request.toJson());

      await Network.postDataWithBody(
        jsonString,
        ApiLink.createProvService,
      );
    } catch (e) {
      throw e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString();
    }
  }
}
