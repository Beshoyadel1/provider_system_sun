import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/pages/first_screen_permissions/screens/data_container_in_list_data_first_screen_permissions.dart';

class ListDataFirstScreenPermissions extends StatelessWidget {
  const ListDataFirstScreenPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const DataContainerInListDataFirstScreenPermissions(),
    );
  }
}
