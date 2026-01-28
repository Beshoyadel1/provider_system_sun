import 'package:dio/dio.dart';
import '../../../../core/model/employee_management/get_employee_services_model/get_employee_services_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getEmployeeServicesFunction({
  required GetEmployeeServicesRequest getEmployeeServicesRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      getEmployeeServicesRequest.toJson(), // params
      ApiLink.getEmployeeServices,
    );
    AppSnackBar.showSuccess("Get Employee Services successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}