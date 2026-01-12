import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../features/service_settings/shared_packages_in_service_settings/sub/add_shared_packages_in_service_settings/screens/data_screen_in_add_shared_packages_in_service_settings.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/icon_car_orange_text_of_car_spare_parts_in_service_settings.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/first_row_data_container_in_list_data_add_spare_parts_in_service_settings.dart';

class DataContainerInListDataAddSharedPackagesInServiceSettings
    extends StatelessWidget {
  const DataContainerInListDataAddSharedPackagesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FirstRowDataContainerInListDataAddSparePartsInServiceSettings(
            text1: AppLanguageKeys.sharedPackages,
            text2: AppLanguageKeys.addDifferentServices,
            textContainer: AppLanguageKeys.back,
          ),
          IconCarOrangeTextOfCarSparePartsInServiceSettings(
            imagePath: AppImageKeys.car4_service,
            text: AppLanguageKeys.sharedPackages,
          ),
          DataScreenInAddSharedPackagesInServiceSettings()
        ],
      ),
    );
  }
}
