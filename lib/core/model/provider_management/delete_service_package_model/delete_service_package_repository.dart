import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/delete_service_package_model/delete_service_package_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> deleteServicePackageFunction({
  required DeleteServicePackageRequest deleteServicePackageRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      deleteServicePackageRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.provicerServicePackage}/DeleteServicePackage",
    );
    AppSnackBar.showSuccess("Delete Service Package successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}