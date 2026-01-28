import 'package:dio/dio.dart';
import 'package:sun_web_system/core/model/employee_management/assign_service_to_employee_model/assign_service_to_employee_request.dart';
import '../../../../core/model/employee_management/get_employee_services_model/get_employee_services_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> assignServiceToEmployeeFunction({
  required AssignServiceToEmployeeRequest assignServiceToEmployeeRequest,
}) async {
  try {
    await Network.postDataWithBodyAndParams(
      {},
      assignServiceToEmployeeRequest.toJson(), // params
      ApiLink.assignServiceToEmployee,
    );
    AppSnackBar.showSuccess("Assign Service To Employee successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}