import 'package:dio/dio.dart';
import '../../request/update_service_package_request/update_service_package_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';

Future<void> updateServicePackageFunction({
  required UpdateServicePackageRequest updateServicePackageRequest,
}) async {
  try {
    final response = await Network.postDataWithBody(
      updateServicePackageRequest.toJson(),
      ApiLink.updateServicePackage,
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
