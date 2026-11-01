import 'package:sun_web_system/core/api/api_result.dart';
import '../../request/delete_prov_service_request/delete_prov_service_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';

Future<bool> deleteProvServiceFunction({
  required DeleteProvServiceRequest deleteProvServiceRequest,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      deleteProvServiceRequest.toJson(),
      ApiLink.deleteProvService,
    );
    ApiResult.requireSuccess(response);

    return true;
  } catch (e) {
    rethrow;
  }
}