import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';
import 'package:sun_web_system/features/employee/data/request/get_employees_request/get_employees_request.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/api/dio_function/dio_controller.dart';


Future<List<EmployeeModel>> getEmployeesFunction({
  required GetEmployeesRequest request,
}) async {
  try {
    final response = await Network.getDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.getBranchEmployees,
    );

    final responseData = response.data;

    final List data = responseData['data'] ?? [];

    return data.map((e) => EmployeeModel.fromJson(e)).toList();
  } catch (e) {
    throw Exception(e.toString());
  }
}