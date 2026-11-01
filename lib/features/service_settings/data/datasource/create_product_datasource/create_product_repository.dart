import 'package:sun_web_system/core/api/api_result.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../request/create_product_request/create_product_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<void> createProductApi({
  required CreateProductRequest request,
}) async {
  try {
    final jsonString = json.encode(request.toJson());

    final response = await Network.postDataWithBody(
      jsonString,
      ApiLink.createProduct,
    );
    ApiResult.requireSuccess(response);
  } catch (e) {
    throw Exception(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}