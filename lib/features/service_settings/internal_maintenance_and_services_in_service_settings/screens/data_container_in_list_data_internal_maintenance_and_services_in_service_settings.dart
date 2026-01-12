import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/service_settings/internal_maintenance_and_services_in_service_settings/screens/icon_car_orange_text_of_internal_maintenance_and_services_in_service_settings.dart';
import '../../../../../../features/service_settings/custom_widget/expansion_container_setting_widget.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/first_row_in_data_container_in_list_data_first_screen_service_setting.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';


class DataContainerInListDataInternalMaintenanceAndServicesInServiceSettings
    extends StatelessWidget {
  const DataContainerInListDataInternalMaintenanceAndServicesInServiceSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FirstRowInDataContainerInListDataFirstScreenServiceSetting(),
          IconCarOrangeTextOfInternalMaintenanceAndServicesInServiceSettings(),
          ExpansionContainerSettingWidget(
            imagePath: AppImageKeys.service33,
            text: AppLanguageKeys.mobileServices,
            isDoneTask: true,
          ),
          ExpansionContainerSettingWidget(
            imagePath: AppImageKeys.service44,
            text: AppLanguageKeys.towTruckRequest,
          ),
          ExpansionContainerSettingWidget(
            imagePath: AppImageKeys.service01,
            text: AppLanguageKeys.highwayService,
          ),
        ],
      ),
    );
  }
}
