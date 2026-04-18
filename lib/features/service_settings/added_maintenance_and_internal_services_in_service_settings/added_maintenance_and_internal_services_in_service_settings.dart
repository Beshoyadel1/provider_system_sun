import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/container_last_two_button_in_added_maintenance_and_internal_services_in_service_settings.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/list_data_added_maintenance_and_internal_services_in_service_settings.dart';
import '../../../../../../features/service_settings/custom_widget/appbar_dashboard_widget.dart';
import '../../../../../../features/service_settings/custom_widget/backgroundDesktop.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../core/theming/colors.dart';

class AddedMaintenanceAndInternalServicesInServiceSettings
    extends StatelessWidget {
  const AddedMaintenanceAndInternalServicesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   BlocProvider(
      create: (_) => CreateProvServiceCubit(),
      child: const Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      child: const ListDataAddedMaintenanceAndInternalServicesInServiceSettings()),
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: ContainerLastTwoButtonInAddedMaintenanceAndInternalServicesInServiceSettings(),
      ),
    );
  }
}
