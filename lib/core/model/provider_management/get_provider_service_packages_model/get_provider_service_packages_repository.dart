import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/get_provider_service_packages_model/get_provider_service_packages_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getProviderServicePackagesFunction({
  required GetProviderServicePackagesRequest getProviderServicePackagesRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getProviderServicePackagesRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.provicerServicePackage}/GetProviderServicePackages",
    );
    AppSnackBar.showSuccess("Get Provider Service Packages successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}