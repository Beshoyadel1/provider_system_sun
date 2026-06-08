import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api/dio_function/failures.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/update_user_datasource/update_user_repository.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_emp_request.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/employee/data/datasource/get_branch_employees_datasource/get_branch_employees_repository.dart';
import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';
import 'package:sun_web_system/features/employee/data/request/get_employees_request/get_employees_request.dart';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit() : super(EmployeeInitial());

  List<EmployeeModel> employees = [];

  Future<void> getEmployees() async {
    emit(EmployeeLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null) {
        emit(
          const EmployeeError(
            'User not found',
          ),
        );
        return;
      }

      employees = await getEmployeesFunction(
        request: GetEmployeesRequest(
          providerId: user.userid!,
        ),
      );

      emit(
        EmployeeSuccess(
          employees,
        ),
      );
    } catch (e) {
      emit(
        EmployeeError(
          e is DioException
              ? responseOfStatusCode(
            e.response?.statusCode,
          )
              : e.toString(),
        ),
      );
    }
  }

  Future<void> updateEmployee(
      CreateUserEmpRequest request,
      ) async {
    emit(EmployeeUpdateLoading());

    try {
      await updateUserEmployeeFunction(
        createUserRequest: request,
      );

      emit(EmployeeUpdateSuccess());

      await getEmployees();
    } catch (e) {
      emit(
        EmployeeUpdateError(
          e.toString(),
        ),
      );

      emit(
        EmployeeSuccess(
          employees,
        ),
      );
    }
  }
}