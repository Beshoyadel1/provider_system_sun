import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../features/service_settings/internal_maintenance_and_services_in_service_settings/screens/list_data_internal_maintenance_and_services_in_service_settings.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/container_last_two_button_in_added_maintenance_and_internal_services_in_service_settings.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';

class InternalMaintenanceAndServicesInServiceSettings extends StatelessWidget {
  const InternalMaintenanceAndServicesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child:
                        ListDataInternalMaintenanceAndServicesInServiceSettings()),
              ),
            ],
          ),
        ),
      ),
      //  bottomNavigationBar: ContainerLastTwoButtonInAddedMaintenanceAndInternalServicesInServiceSettings(),
    );
  }
}
