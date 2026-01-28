import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/get_service_provider_details_for_app_user_model/get_service_provider_details_for_app_user_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getServiceProviderDetailsForAppUserFunction({
  required GetServiceProviderDetailsForAppUserRequest getServiceProviderDetailsForAppUserRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getServiceProviderDetailsForAppUserRequest.toJson(), // params
      ApiLink.getServiceProviderDetailsForAppUser,
    );
    AppSnackBar.showSuccess("Get Service Provider Details For App User successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}