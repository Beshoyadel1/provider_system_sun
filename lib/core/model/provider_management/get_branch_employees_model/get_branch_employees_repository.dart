import 'package:dio/dio.dart';
import '../../../../core/model/provider_management/get_branch_employees_model/get_branch_employees_request.dart';
import '../../../../core/api/dio_function/apiConfig.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../../../../core/api/dio_function/failures.dart';

Future<void> getBranchEmployeesFunction({
  required GetBranchEmployeesRequest getBranchEmployeesRequest,
}) async {
  try {
    await Network.getDataWithBodyAndParams(
      {},
      getBranchEmployeesRequest.toJson(), // params
      "${ApiConfig.baseUrlApi}/${ApiConfig.branch}/GetBranchEmployees",
    );
    AppSnackBar.showSuccess("Get Branch Employees successfully");
  } catch (e) {
    AppSnackBar.showError(
      e is DioException
          ? responseOfStatusCode(e.response?.statusCode)
          : e.toString(),
    );
  }
}