import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../../features/service_settings/shared_packages_in_service_settings/sub/add_shared_packages_in_service_settings/screens/part_two_package_in_data_container_in_list_data_add_shared_packages_in_service_settings.dart';
import '../../../../../../../../features/service_settings/shared_packages_in_service_settings/sub/add_shared_packages_in_service_settings/screens/part_one_package_in_data_container_in_list_data_add_shared_packages_in_service_settings.dart';

class DataScreenInAddSharedPackagesInServiceSettings extends StatelessWidget {
  const DataScreenInAddSharedPackagesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isTab = size.width > ValuesOfAllApp.customTabWidth - 5;

    return isTab
        ? const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child:
                      PartOnePackageInDataContainerInListDataAddSharedPackagesInServiceSettings()),
              Flexible(
                  child:
                      PartTwoPackageInDataContainerInListDataAddSharedPackagesInServiceSettings()),
            ],
          )
        : const Column(
            children: [
              PartOnePackageInDataContainerInListDataAddSharedPackagesInServiceSettings(),
            ],
          );
  }
}
