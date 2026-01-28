import 'package:dio/dio.dart';
import '../../../../core/model/statistics/get_admin_most_requested_services_model/get_admin_most_requested_services_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';


Future<void> getAdminMostRequestedServicesFunction({
  required GetAdminMostRequestedServicesRequest getAdminMostRequestedServicesRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getAdminMostRequestedServicesRequest.toJson(), // params
        ApiLink.getAdminMostRequestedServices
    );
    AppSnackBar.showSuccess("Get Admin Most Requested Services successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}