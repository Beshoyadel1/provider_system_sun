import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/data_container_in_list_data_added_maintenance_and_internal_services_in_service_settings.dart';
import '../../../../../../core/theming/colors.dart';

class ListDataAddedMaintenanceAndInternalServicesInServiceSettings
    extends StatelessWidget {
  final String textServiceScreen;
  final Uint8List imageMemory;
  const ListDataAddedMaintenanceAndInternalServicesInServiceSettings(
      {super.key,required this.textServiceScreen,required this.imageMemory});

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
          create: (_) => ServiceSettingsCubit()..getServices(parentId: 1),
           child: DataContainerInListDataAddedMaintenanceAndInternalServicesInServiceSettings(
             textServiceScreen:textServiceScreen ,
             imageMemory:imageMemory ,
           )
      ),
    );
  }
}