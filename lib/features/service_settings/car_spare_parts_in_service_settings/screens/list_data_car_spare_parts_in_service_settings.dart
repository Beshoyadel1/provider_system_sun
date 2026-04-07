import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/data_container_in_list_data_added_maintenance_and_internal_services_in_service_settings.dart';
import 'package:sun_web_system/features/service_settings/logic/cubit/service_settings_cubit/service_settings_cubit.dart';
import '../../../../../../core/theming/colors.dart';

class ListDataCarSparePartsInServiceSettings extends StatelessWidget {
  const ListDataCarSparePartsInServiceSettings({super.key});

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
      child: BlocProvider(
          create: (_) => ServiceSettingsCubit()..getServices(parentId: 3),
          child: const DataContainerInListDataAddedMaintenanceAndInternalServicesInServiceSettings()),
    );
  }
}