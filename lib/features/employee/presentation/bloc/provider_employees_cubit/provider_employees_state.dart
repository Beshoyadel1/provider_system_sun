import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';

abstract class ProviderEmployeesState {}

class ProviderEmployeesInitial extends ProviderEmployeesState {}

class ProviderEmployeesLoading extends ProviderEmployeesState {}

class ProviderEmployeesSuccess extends ProviderEmployeesState {
  final List<CreateUserRequest> employees;

  ProviderEmployeesSuccess(this.employees);
}

class ProviderEmployeesError extends ProviderEmployeesState {
  final String message;

  ProviderEmployeesError(this.message);
}
class EmployeeUpdateLoading extends ProviderEmployeesState {}

class EmployeeUpdateSuccess extends ProviderEmployeesState {}

class EmployeeUpdateError extends ProviderEmployeesState {
  final String message;

  EmployeeUpdateError(this.message);
}

