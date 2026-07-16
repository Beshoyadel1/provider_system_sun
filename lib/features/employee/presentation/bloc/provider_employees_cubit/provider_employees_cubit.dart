import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/update_user_datasource/update_user_repository.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_emp_request.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/employee/data/datasource/get_provider_employees_datasource/get_provider_employees_repository.dart';
import 'package:sun_web_system/features/employee/data/request/get_provider_employees_request/get_provider_employees_repository.dart';
import 'provider_employees_state.dart';

class ProviderEmployeesCubit
    extends Cubit<ProviderEmployeesState> {
  ProviderEmployeesCubit()
      : super(ProviderEmployeesInitial());

  List<CreateUserRequest> employees = [];

  Future<void> getEmployees() async {
    emit(ProviderEmployeesLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      debugPrint(
        'provid = ${user?.userid}',
      );
      employees = await getProviderEmployees(
        request: GetProviderEmployeesRepository(
          provId: user!.userid!,
        ),
      );

      emit(
        ProviderEmployeesSuccess(employees),
      );
    } catch (e) {
      emit(
        ProviderEmployeesError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> updateEmployee(
      CreateUserEmpRequest request,
      ) async {
    emit(EmployeeUpdateLoading());

    try {
      final result =
      await updateUserEmployeeFunction(
        createUserRequest: request,
      );

      if (!result.success) {
        emit(
          EmployeeUpdateError(
            result.message,
          ),
        );
        return;
      }

      emit(EmployeeUpdateSuccess());
    } catch (e) {
      emit(
        EmployeeUpdateError(
          e.toString(),
        ),
      );
    }
  }
}