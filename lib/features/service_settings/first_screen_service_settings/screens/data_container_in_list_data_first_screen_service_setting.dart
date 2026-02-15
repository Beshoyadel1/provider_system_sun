import 'package:flutter/cupertino.dart';
import '../../../../../../features/service_settings/shared_packages_in_service_settings/shared_packages_in_service_settings.dart';
import '../../../../../../features/service_settings/car_spare_parts_in_service_settings/car_spare_parts_in_service_settings.dart';
import '../../../../../../features/service_settings/internal_maintenance_and_services_in_service_settings/internal_maintenance_and_services_in_service_settings.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/added_maintenance_and_internal_services_in_service_settings.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../features/service_settings/custom_widget/container_in_data_container_in_list_data_first_screen_service_setting_widget.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/first_row_in_data_container_in_list_data_first_screen_service_setting.dart';

class DataContainerInListDataFirstScreenServiceSetting extends StatelessWidget {
  const DataContainerInListDataFirstScreenServiceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FirstRowInDataContainerInListDataFirstScreenServiceSetting(
            text1: AppLanguageKeys.nissanServiceSettings,
            text2: AppLanguageKeys.serviceSettingsDetails,
          ),
          ContainerInDataContainerInListDataFirstScreenServiceSettingWidget(
            imagePath: AppImageKeys.car1_service,
            title: AppLanguageKeys.internalServices,
            isTaskEdit: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                NavigateToPageWidget(
                  AddedMaintenanceAndInternalServicesInServiceSettings(),
                ),
              );
            },
          ),
          ContainerInDataContainerInListDataFirstScreenServiceSettingWidget(
            imagePath: AppImageKeys.car2_service,
            title: AppLanguageKeys.mobileAndTransportServices,
            isTaskEdit: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                NavigateToPageWidget(
                  InternalMaintenanceAndServicesInServiceSettings(),
                ),
              );
            },
          ),
          ContainerInDataContainerInListDataFirstScreenServiceSettingWidget(
            imagePath: AppImageKeys.car3_service,
            title: AppLanguageKeys.carSpareParts,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                NavigateToPageWidget(
                  CarSparePartsInServiceSettings(),
                ),
              );
            },
          ),
          ContainerInDataContainerInListDataFirstScreenServiceSettingWidget(
            imagePath: AppImageKeys.car4_service,
            title: AppLanguageKeys.sharedPackages,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                NavigateToPageWidget(
                  SharedPackagesInServiceSettings(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
