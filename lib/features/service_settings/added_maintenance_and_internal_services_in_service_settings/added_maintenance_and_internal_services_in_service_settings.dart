import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/prov_services_cubit/prov_services_cubit.dart';
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
    return   MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CreateProvServiceCubit(),
        ),
        BlocProvider(
          create: (_) => ProvServicesCubit(),
        ),
      ],
      child: const Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: SafeArea(
          child: Padding(
            padding:  EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      child:  ListDataAddedMaintenanceAndInternalServicesInServiceSettings()),
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
