import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_state.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_edit_employee_data/facility_account_emp/sub/employee_permission_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_cubit.dart';

import '../../../../../../../core/theming/colors.dart';

class SelectEmployeePermissions extends StatelessWidget {
  final bool isEditMode;

  const SelectEmployeePermissions({
    super.key,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderEmployeesCubit, ProviderEmployeesState>(
      buildWhen: (previous, current) {
        return current is EmployeePermissionsChanged ||
            current is EmployeeSelectedState;
      },
      builder: (context, state) {
        final cubit = context.read<ProviderEmployeesCubit>();

        final permissions =
            cubit.selectedPermissions ??
                cubit.emptyPermissions;

        final allPermissions = <Widget>[
          PermissionWithIconText(
            permission: EmployeePermissionType.acceptAllOrders,
            text: AppLanguageKeys.acceptAllOrders,
            icon: Icons.assignment_turned_in_outlined,
            readOnly: !isEditMode,
          ),

          PermissionWithIconText(
            permission: EmployeePermissionType.changeOrderStatus,
            text: AppLanguageKeys.changeOrderStatus,
            icon: Icons.sync_alt,
            readOnly: !isEditMode,
          ),

          PermissionWithIconText(
            permission: EmployeePermissionType.harage,
            text: AppLanguageKeys.harage,
            icon: Icons.directions_car_outlined,
            readOnly: !isEditMode,
          ),

          PermissionWithIconText(
            permission:
            EmployeePermissionType.maintenanceAndInternalServices,
            text: AppLanguageKeys.maintenance,
            icon: Icons.build_outlined,
            readOnly: !isEditMode,
          ),

          PermissionWithIconText(
            permission: EmployeePermissionType.mobileServices,
            text: AppLanguageKeys.mobileService,
            icon: Icons.phone_android_outlined,
            readOnly: !isEditMode,
          ),

          PermissionWithIconText(
            permission: EmployeePermissionType.spareParts,
            text: AppLanguageKeys.spareParts,
            icon: Icons.settings_outlined,
            readOnly: !isEditMode,
          ),

          PermissionWithIconText(
            permission: EmployeePermissionType.servicePackage,
            text: AppLanguageKeys.servicePackage,
            icon: Icons.inventory_2_outlined,
            readOnly: !isEditMode,
          ),

          PermissionWithIconText(
            permission: EmployeePermissionType.petrol,
            text: AppLanguageKeys.petrol,
            icon: Icons.local_gas_station_outlined,
            readOnly: !isEditMode,
          ),
        ];

        // ==========================================
        // CREATE / EDIT
        // ==========================================

        if (isEditMode) {
          return Wrap(
            spacing: 25,
            runSpacing: 20,
            children: allPermissions,
          );
        }

        // ==========================================
        // VIEW
        // ==========================================

        final selectedPermissions = <Widget>[];

        if (permissions.acceptallorders == true) {
          selectedPermissions.add(
            const PermissionWithIconText(
              permission: EmployeePermissionType.acceptAllOrders,
              text: AppLanguageKeys.acceptAllOrders,
              icon: Icons.assignment_turned_in_outlined,
              readOnly: true,
            ),
          );
        }

        if (permissions.changeorderstatus == true) {
          selectedPermissions.add(
            const PermissionWithIconText(
              permission: EmployeePermissionType.changeOrderStatus,
              text: AppLanguageKeys.changeOrderStatus,
              icon: Icons.sync_alt,
              readOnly: true,
            ),
          );
        }

        if (permissions.harage == true) {
          selectedPermissions.add(
            const PermissionWithIconText(
              permission: EmployeePermissionType.harage,
              text: AppLanguageKeys.harage,
              icon: Icons.directions_car_outlined,
              readOnly: true,
            ),
          );
        }

        if (permissions.maintenanceandinternalservices == true) {
          selectedPermissions.add(
            const PermissionWithIconText(
              permission:
              EmployeePermissionType.maintenanceAndInternalServices,
              text: AppLanguageKeys.maintenance,
              icon: Icons.build_outlined,
              readOnly: true,
            ),
          );
        }

        if (permissions.mobileservices == true) {
          selectedPermissions.add(
            const PermissionWithIconText(
              permission: EmployeePermissionType.mobileServices,
              text: AppLanguageKeys.mobileService,
              icon: Icons.phone_android_outlined,
              readOnly: true,
            ),
          );
        }

        if (permissions.spareparts == true) {
          selectedPermissions.add(
            const PermissionWithIconText(
              permission: EmployeePermissionType.spareParts,
              text: AppLanguageKeys.spareParts,
              icon: Icons.settings_outlined,
              readOnly: true,
            ),
          );
        }

        if (permissions.servicepackage == true) {
          selectedPermissions.add(
            const PermissionWithIconText(
              permission: EmployeePermissionType.servicePackage,
              text: AppLanguageKeys.servicePackage,
              icon: Icons.inventory_2_outlined,
              readOnly: true,
            ),
          );
        }

        if (permissions.petrol == true) {
          selectedPermissions.add(
            const  PermissionWithIconText(
              permission: EmployeePermissionType.petrol,
              text: AppLanguageKeys.petrol,
              icon: Icons.local_gas_station_outlined,
              readOnly: true,
            ),
          );
        }

        // ==========================================
        // NO PERMISSIONS
        // ==========================================

        if (selectedPermissions.isEmpty) {
          return const TextInAppWidget(
            text: AppLanguageKeys.noPermissionsAssigned,
            textSize: 14,
            textColor: AppColors.greyColor,
          );
        }

        return Wrap(
          spacing: 25,
          runSpacing: 20,
          children: selectedPermissions,
        );
      },
    );
  }
}