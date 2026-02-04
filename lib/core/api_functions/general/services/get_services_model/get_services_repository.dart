import 'package:dio/dio.dart';
import '../../../../../core/api_functions/general/services/get_services_model/get_services_request.dart';
import '../../../../../core/api/dio_function/apiConfig.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';
import '../../../../../core/api/dio_function/failures.dart';
import '../../../../../core/language/language_constant.dart';

Future<void> getServicesFunction({
  required GetServicesRequest getServicesRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getServicesRequest.toJson(), // params
      ApiLink.getServices,
    );
    AppSnackBar.showSuccess(AppLanguageKeys.getServicesSuccessfully);
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}
