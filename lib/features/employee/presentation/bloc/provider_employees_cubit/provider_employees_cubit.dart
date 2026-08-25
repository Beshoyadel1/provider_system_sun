import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/update_user_datasource/update_user_repository.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_emp_request.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/employee_wrapper_request.dart';

import 'package:sun_web_system/features/employee/data/datasource/get_provider_employees_datasource/get_provider_employees_repository.dart';
import 'package:sun_web_system/features/employee/data/request/get_provider_employees_request/get_provider_employees_repository.dart';

import 'provider_employees_state.dart';

class ProviderEmployeesCubit extends Cubit<ProviderEmployeesState> {
  ProviderEmployeesCubit()
      : super(ProviderEmployeesInitial());

  // =========================================================
  // EMPLOYEES
  // =========================================================

  List<CreateUserRequest> employees = [];

  // =========================================================
  // SELECTED EMPLOYEE
  // =========================================================

  CreateUserRequest? selectedEmployee;

  // =========================================================
  // PERMISSIONS
  // =========================================================

  EmployeePermissionsModel? selectedPermissions;
  // =========================================================
// EMPTY PERMISSIONS
// =========================================================

  EmployeePermissionsModel get emptyPermissions {
    return const EmployeePermissionsModel(
      acceptallorders: false,
      changeorderstatus: false,
      harage: false,
      maintenanceandinternalservices: false,
      mobileservices: false,
      spareparts: false,
      servicepackage: false,
      petrol: false,
    );
  }

  // =========================================================
  // SET SELECTED EMPLOYEE
  // =========================================================

  void setSelectedEmployee(
      CreateUserRequest employee,
      ) {
    selectedEmployee = employee;

    selectedPermissions =
        employee.employeeDetails?.permissions ??
            emptyPermissions;

    debugPrint(
      '========================================',
    );

    debugPrint(
      'SELECTED EMPLOYEE',
    );

    debugPrint(
      'ID: ${employee.userid}',
    );

    debugPrint(
      'Name: ${employee.username}',
    );

    debugPrint(
      'Services: '
          '${employee.employeeDetails?.serviceIds}',
    );

    debugPrint(
      'Permissions: '
          '$selectedPermissions',
    );

    debugPrint(
      '========================================',
    );

    emit(
      EmployeeSelectedState(
        employee: employee,
      ),
    );
  }

  void clearSelectedEmployee() {
    selectedEmployee = null;
    selectedPermissions = null;
  }

  // =========================================================
  // SET PERMISSIONS
  // =========================================================

  void setPermissions(
      EmployeePermissionsModel? permissions,
      ) {
    selectedPermissions =
        permissions ?? emptyPermissions;

    debugPrint(
      '========================================',
    );

    debugPrint(
      'PERMISSIONS SET',
    );

    debugPrint(
      '$selectedPermissions',
    );

    debugPrint(
      '========================================',
    );

    emit(
      EmployeePermissionsChanged(
        permissions: selectedPermissions!,
      ),
    );
  }
  void clearPermissions() {
    selectedPermissions = emptyPermissions;

    emit(
      EmployeePermissionsChanged(
        permissions: selectedPermissions!,
      ),
    );
  }

  // =========================================================
  // UPDATE SINGLE PERMISSION
  // =========================================================

  void updatePermission({
    bool? acceptallorders,
    bool? changeorderstatus,
    bool? harage,
    bool? maintenanceandinternalservices,
    bool? mobileservices,
    bool? spareparts,
    bool? servicepackage,
    bool? petrol,
  }) {
    final oldPermissions =
        selectedPermissions ??
            const EmployeePermissionsModel();

    selectedPermissions =
        oldPermissions.copyWith(
          acceptallorders:
          acceptallorders,

          changeorderstatus:
          changeorderstatus,

          harage:
          harage,

          maintenanceandinternalservices:
          maintenanceandinternalservices,

          mobileservices:
          mobileservices,

          spareparts:
          spareparts,

          servicepackage:
          servicepackage,

          petrol:
          petrol,
        );

    debugPrint(
      '========================================',
    );

    debugPrint(
      'SINGLE PERMISSION UPDATED',
    );

    debugPrint(
      '$selectedPermissions',
    );

    debugPrint(
      '========================================',
    );

    emit(
      EmployeePermissionsChanged(
        permissions: selectedPermissions!,
      ),
    );
  }

  // =========================================================
  // ACCEPT ALL ORDERS
  // =========================================================

  void setAcceptAllOrders(bool value) {
    updatePermission(
      acceptallorders: value,
    );
  }

  // =========================================================
  // CHANGE ORDER STATUS
  // =========================================================

  void setChangeOrderStatus(bool value) {
    updatePermission(
      changeorderstatus: value,
    );
  }

  // =========================================================
  // HARAGE
  // =========================================================

  void setHarage(bool value) {
    updatePermission(
      harage: value,
    );
  }

  // =========================================================
  // MAINTENANCE & INTERNAL SERVICES
  // =========================================================

  void setMaintenanceAndInternalServices(
      bool value,
      ) {
    updatePermission(
      maintenanceandinternalservices: value,
    );
  }

  // =========================================================
  // MOBILE SERVICES
  // =========================================================

  void setMobileServices(bool value) {
    updatePermission(
      mobileservices: value,
    );
  }

  // =========================================================
  // SPARE PARTS
  // =========================================================

  void setSpareParts(bool value) {
    updatePermission(
      spareparts: value,
    );
  }

  // =========================================================
  // SERVICE PACKAGE
  // =========================================================

  void setServicePackage(bool value) {
    updatePermission(
      servicepackage: value,
    );
  }

  // =========================================================
  // PETROL
  // =========================================================

  void setPetrol(bool value) {
    updatePermission(
      petrol: value,
    );
  }

  // =========================================================
  // GET EMPLOYEES
  // =========================================================

  Future<void> getEmployees() async {
    if (isClosed) return;

    emit(
      ProviderEmployeesLoading(),
    );

    try {
      final user =
      await AuthLocalStorage.getUser();

      if (user == null ||
          user.userid == null) {
        emit(
          ProviderEmployeesError(
            'User not found',
          ),
        );

        return;
      }

      employees =
      await getProviderEmployees(
        request:
        GetProviderEmployeesRepository(
          provId: user.userid!,
        ),
      );

      if (isClosed) return;

      emit(
        ProviderEmployeesSuccess(
          employees,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        ProviderEmployeesError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

  // =========================================================
  // UPDATE EMPLOYEE
  // =========================================================

  Future<void> updateEmployee(
      CreateUserEmpRequest request,
      ) async {
    if (isClosed) return;

    emit(
      EmployeeUpdateLoading(),
    );

    try {
      // =====================================================
      // OLD EMPLOYEE
      // =====================================================

      final oldEmployee =
          selectedEmployee;


      if (oldEmployee == null) {
        emit(
          EmployeeUpdateError(
            'Employee not selected',
          ),
        );

        return;
      }

      // =====================================================
      // OLD DATA
      // =====================================================

      final oldWrapper =
          oldEmployee.employeeDetails;

      final oldEmployeeDetails =
          oldWrapper?.employeeDetails;

      final oldServices =
          oldWrapper?.serviceIds ??
              const <int>[];

      final oldPermissions =
          oldWrapper?.permissions;

      // =====================================================
      // REQUEST DATA
      // =====================================================

      final requestEmployeeDetails =
          request.employeeDetails;

      final newEmployeeDetails =
          requestEmployeeDetails
              ?.employeeDetails;

      final newServices =
          requestEmployeeDetails
              ?.serviceIds;

      final newPermissions =
          requestEmployeeDetails
              ?.permissions;

      // =====================================================
      // FINAL PERMISSIONS
      // =====================================================

      final finalPermissions =
          newPermissions ??
              selectedPermissions ??
              oldPermissions;

      // =====================================================
      // FINAL REQUEST
      // =====================================================

      final updateRequest =
      CreateUserEmpRequest(
        // ===================================================
        // USER DATA
        // ===================================================

        userid:
        oldEmployee.userid,

        username:
        request.username ??
            oldEmployee.username,

        phone:
        request.phone ??
            oldEmployee.phone,

        email:
        request.email ??
            oldEmployee.email,

        age:
        request.age ??
            oldEmployee.age,

        gender:
        request.gender ??
            oldEmployee.gender,

        // Employee
        type: 5,

        // ===================================================
        // OLD DATA IF NOT MODIFIED
        // ===================================================

        nationality:
        request.nationality ??
            oldEmployee.nationality,

        isActive:
        request.isActive ??
            oldEmployee.isActive,

        joinDate:
        request.joinDate ??
            oldEmployee.joinDate,

        referralCode:
        request.referralCode ??
            oldEmployee.referralCode,

        image:
        request.image ??
            oldEmployee.image,

        fcmToken:
        request.fcmToken ??
            oldEmployee.fcmToken,

        defaultcarid:
        request.defaultcarid ??
            oldEmployee.defaultcarid,

        // ===================================================
        // EMPLOYEE DETAILS
        // ===================================================

        employeeDetails:
        EmployeeWrapperRequest(
          employeeDetails:
          newEmployeeDetails ??
              oldEmployeeDetails,

          serviceIds:
          newServices ??
              oldServices,

          permissions:
          finalPermissions,
        ),
      );

      // =====================================================
      // DEBUG
      // =====================================================

      debugPrint(
        '========================================',
      );

      debugPrint(
        'UPDATE EMPLOYEE',
      );

      debugPrint(
        'ID: ${updateRequest.userid}',
      );

      debugPrint(
        'TYPE: ${updateRequest.type}',
      );

      debugPrint(
        'USERNAME: ${updateRequest.username}',
      );

      debugPrint(
        'PHONE: ${updateRequest.phone}',
      );

      debugPrint(
        'EMAIL: ${updateRequest.email}',
      );

      debugPrint(
        'SERVICES: '
            '${updateRequest.employeeDetails?.serviceIds}',
      );

      debugPrint(
        'PERMISSIONS:',
      );

      debugPrint(
        'ACCEPT ALL ORDERS: '
            '${updateRequest.employeeDetails?.permissions?.acceptallorders}',
      );

      debugPrint(
        'CHANGE ORDER STATUS: '
            '${updateRequest.employeeDetails?.permissions?.changeorderstatus}',
      );

      debugPrint(
        'HARAGE: '
            '${updateRequest.employeeDetails?.permissions?.harage}',
      );

      debugPrint(
        'MAINTENANCE INTERNAL: '
            '${updateRequest.employeeDetails?.permissions?.maintenanceandinternalservices}',
      );

      debugPrint(
        'MOBILE SERVICES: '
            '${updateRequest.employeeDetails?.permissions?.mobileservices}',
      );

      debugPrint(
        'SPARE PARTS: '
            '${updateRequest.employeeDetails?.permissions?.spareparts}',
      );

      debugPrint(
        'SERVICE PACKAGE: '
            '${updateRequest.employeeDetails?.permissions?.servicepackage}',
      );

      debugPrint(
        'PETROL: '
            '${updateRequest.employeeDetails?.permissions?.petrol}',
      );

      debugPrint(
        '========================================',
      );

      // =====================================================
      // API
      // =====================================================

      final result =
      await updateUserEmployeeFunction(
        createUserRequest:
        updateRequest,
      );

      if (isClosed) return;

      // =====================================================
      // SUCCESS
      // =====================================================

      if (result.success) {
        final updatedEmployee =
        CreateUserRequest(
          userid:
          updateRequest.userid,

          username:
          updateRequest.username,

          phone:
          updateRequest.phone,

          email:
          updateRequest.email,

          age:
          updateRequest.age,

          gender:
          updateRequest.gender,

          type:
          updateRequest.type,

          nationality:
          updateRequest.nationality,

          isActive:
          updateRequest.isActive,

          joinDate:
          updateRequest.joinDate,

          referralCode:
          updateRequest.referralCode,

          image:
          updateRequest.image,

          fcmToken:
          updateRequest.fcmToken,

          defaultcarid:
          updateRequest.defaultcarid,

          employeeDetails:
          updateRequest.employeeDetails,
        );

        // ===================================================
        // UPDATE SELECTED EMPLOYEE
        // ===================================================

        selectedEmployee =
            updatedEmployee;

        selectedPermissions =
            updateRequest
                .employeeDetails
                ?.permissions;

        // ===================================================
        // UPDATE EMPLOYEE IN LIST
        // ===================================================

        final index =
        employees.indexWhere(
              (employee) =>
          employee.userid ==
              updatedEmployee.userid,
        );

        if (index != -1) {
          employees[index] =
              updatedEmployee;
        }

        emit(
          EmployeeUpdateSuccess(),
        );

        return;
      }

      // =====================================================
      // ERROR
      // =====================================================

      emit(
        EmployeeUpdateError(
          result.message,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        EmployeeUpdateError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }

}