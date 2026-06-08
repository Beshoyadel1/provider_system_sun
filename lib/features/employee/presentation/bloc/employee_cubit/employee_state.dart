import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';

abstract class EmployeeState {
  const EmployeeState();
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  final List<EmployeeModel> employees;

  const EmployeeSuccess(this.employees);
}

class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message);
}
class EmployeeUpdateLoading extends EmployeeState {}

class EmployeeUpdateSuccess extends EmployeeState {}

class EmployeeUpdateError extends EmployeeState {
  final String message;

  EmployeeUpdateError(this.message);
}