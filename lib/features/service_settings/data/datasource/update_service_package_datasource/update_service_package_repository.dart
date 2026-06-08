import 'dart:convert';
import 'package:dio/dio.dart';
import '../../request/update_service_package_request/update_service_package_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/language/language_constant.dart';

Future<void> updateServicePackageFunction({
  required UpdateServicePackageRequest
  updateServicePackageRequest,
}) async {
  try {
    await Network.postDataWithBody(
      updateServicePackageRequest.toJson(),
      ApiLink.updateServicePackage,
    );
  } on DioException catch (e) {
    throw Exception(
      responseOfStatusCode(e.response?.statusCode),
    );
  } catch (e) {
    throw Exception(e.toString());
  }
}