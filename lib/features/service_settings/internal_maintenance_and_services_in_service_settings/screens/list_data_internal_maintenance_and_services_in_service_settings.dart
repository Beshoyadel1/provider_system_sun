import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/service_settings/internal_maintenance_and_services_in_service_settings/screens/data_container_in_list_data_internal_maintenance_and_services_in_service_settings.dart';
import '../../../../../../core/theming/colors.dart';

class ListDataInternalMaintenanceAndServicesInServiceSettings
    extends StatelessWidget {
  const ListDataInternalMaintenanceAndServicesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
            color: AppColors.greyColor.withOpacity(0.3)
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const DataContainerInListDataInternalMaintenanceAndServicesInServiceSettings(),
    );
  }
}
