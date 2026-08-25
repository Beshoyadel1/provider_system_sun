import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';

import 'package:sun_web_system/features/auth_page/data/model/create_user_model/employee_wrapper_request.dart';

import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/provider_employees_cubit/provider_employees_state.dart';

enum EmployeePermissionType {
  acceptAllOrders,
  changeOrderStatus,
  harage,
  maintenanceAndInternalServices,
  mobileServices,
  spareParts,
  servicePackage,
  petrol,
}

class PermissionWithIconText extends StatelessWidget {
  final EmployeePermissionType permission;
  final String text;
  final IconData icon;
  final bool readOnly;

  const PermissionWithIconText({
    super.key,
    required this.permission,
    required this.text,
    required this.icon,
    this.readOnly = false,
  });

  bool _isSelected(
      EmployeePermissionsModel permissions,
      ) {
    switch (permission) {
      case EmployeePermissionType.acceptAllOrders:
        return permissions.acceptallorders ?? false;

      case EmployeePermissionType.changeOrderStatus:
        return permissions.changeorderstatus ?? false;

      case EmployeePermissionType.harage:
        return permissions.harage ?? false;

      case EmployeePermissionType
          .maintenanceAndInternalServices:
        return permissions
            .maintenanceandinternalservices ??
            false;

      case EmployeePermissionType.mobileServices:
        return permissions.mobileservices ?? false;

      case EmployeePermissionType.spareParts:
        return permissions.spareparts ?? false;

      case EmployeePermissionType.servicePackage:
        return permissions.servicepackage ?? false;

      case EmployeePermissionType.petrol:
        return permissions.petrol ?? false;
    }
  }

  void _toggle(
      BuildContext context,
      bool value,
      ) {
    final cubit =
    context.read<ProviderEmployeesCubit>();

    switch (permission) {
      case EmployeePermissionType.acceptAllOrders:
        cubit.setAcceptAllOrders(value);
        break;

      case EmployeePermissionType.changeOrderStatus:
        cubit.setChangeOrderStatus(value);
        break;

      case EmployeePermissionType.harage:
        cubit.setHarage(value);
        break;

      case EmployeePermissionType
          .maintenanceAndInternalServices:
        cubit.setMaintenanceAndInternalServices(
          value,
        );
        break;

      case EmployeePermissionType.mobileServices:
        cubit.setMobileServices(value);
        break;

      case EmployeePermissionType.spareParts:
        cubit.setSpareParts(value);
        break;

      case EmployeePermissionType.servicePackage:
        cubit.setServicePackage(value);
        break;

      case EmployeePermissionType.petrol:
        cubit.setPetrol(value);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        ProviderEmployeesCubit,
        ProviderEmployeesState>(
      buildWhen: (previous, current) {
        return current
        is EmployeePermissionsChanged ||
            current is EmployeeSelectedState;
      },
      builder: (context, state) {
        final cubit =
        context.read<ProviderEmployeesCubit>();

        final permissions =
            cubit.selectedPermissions ??
                cubit.emptyPermissions;

        final isChecked =
        _isSelected(permissions);

        return InkWell(
          onTap: readOnly
              ? null
              : () {
            _toggle(
              context,
              !isChecked,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                activeColor:
                AppColors.orangeColor,
                value: isChecked,
                onChanged: readOnly
                    ? null
                    : (value) {
                  if (value == null) {
                    return;
                  }

                  _toggle(
                    context,
                    value,
                  );
                },
              ),

              Opacity(
                opacity:
                isChecked ? 1 : 0.5,
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 42,
                      color:
                      AppColors.orangeColor,
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    TextInAppWidget(
                      text: text,
                      textSize: 11,
                      fontWeightIndex:
                      FontSelectionData
                          .regularFontFamily,
                      textColor:
                      AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}