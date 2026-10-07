import 'package:dio/dio.dart';
import '../../model/create_service_package_model/create_service_package_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<void> createServicePackageFunction({
  required CreateServicePackageRequest request,
}) async {
  try {
    final response = await Network.postDataWithBody(
      request.toJson(),
      ApiLink.createServicePackage,
    );
    final body = response.data;
    if (body is! Map || body['success'] != true) {
      throw FormatException(body is Map
          ? body['message']?.toString() ?? 'Package request was not successful'
          : 'Invalid package response');
    }
  } on DioException catch (e) {
    throw Exception(
      responseOfStatusCode(e.response?.statusCode),
    );
  } catch (e) {
    throw Exception(e.toString());
  }
}
