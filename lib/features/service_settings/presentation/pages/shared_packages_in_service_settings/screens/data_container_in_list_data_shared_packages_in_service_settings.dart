import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../features/service_settings/presentation/pages/shared_packages_in_service_settings/screens/list_data_of_packages_in_shared_packages_in_service_settings.dart';
import '../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/screens/icon_car_orange_text_of_car_spare_parts_in_service_settings.dart';

class DataContainerInListDataSharedPackagesInServiceSettings
    extends StatelessWidget {
  const DataContainerInListDataSharedPackagesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FirstRowInDataContainerInListDataFirstScreenServiceSetting(
          //   text1: AppLanguageKeys.sharedPackages,
          //   text2: AppLanguageKeys.addDifferentServices,
          //   textContainer: AppLanguageKeys.back,
          // ),
          IconCarOrangeTextOfCarSparePartsInServiceSettings(
            text: AppLanguageKeys.servicePackage,
            imagePath: AppImageKeys.car4_service,
          ),
          ListDataOfPackagesInSharedPackagesInServiceSettings()
        ],
      ),
    );
  }
}
