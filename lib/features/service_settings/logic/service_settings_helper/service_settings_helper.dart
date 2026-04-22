import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/added_maintenance_and_internal_services_in_service_settings.dart';
import '../../../../../features/service_settings/car_spare_parts_in_service_settings/car_spare_parts_in_service_settings.dart';
import '../../../../../features/service_settings/internal_maintenance_and_services_in_service_settings/internal_maintenance_and_services_in_service_settings.dart';
import '../../../../../features/service_settings/petrol_in_service_settings/petrol_in_service_settings.dart';
import '../../../../../features/service_settings/shared_packages_in_service_settings/shared_packages_in_service_settings.dart';
import '../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../core/api_functions/general/services/get_services_model/service_setting_model.dart';

class ServiceSettingsHelper {
  static List<ServiceSettingModel> filterByParentId({
    required List<ServiceSettingModel> services,
    required int parentId,
  }) {
    return services.where((e) => e.parentId == parentId).toList();
  }

  static String getServiceName({
    required ServiceSettingModel service,
    required bool isArabic,
  }) {
    return isArabic ? service.name ?? '' : service.latinName ?? '';
  }

  static void handleNavigation(BuildContext context, int? id ,String textServiceScreen, Uint8List? imageMemory) {
    switch (id) {
      case 1:
        Navigator.push(
          context,
          NavigateToPageWidget(
            AddedMaintenanceAndInternalServicesInServiceSettings(
              imageMemory: imageMemory!,
              textServiceScreen:textServiceScreen ,
            ),
          ),
        );
        break;

      case 2:
        Navigator.push(
          context,
          NavigateToPageWidget(
             InternalMaintenanceAndServicesInServiceSettings(
              imageMemory: imageMemory!,
              textServiceScreen:textServiceScreen ,
            ),
          ),
        );
        break;

      case 3:
        Navigator.push(
          context,
          NavigateToPageWidget(
             CarSparePartsInServiceSettings(
               imageMemory: imageMemory!,
               textServiceScreen:textServiceScreen ,
             ),
          ),
        );
        break;

      case 4:
        Navigator.push(
          context,
          NavigateToPageWidget(
            const SharedPackagesInServiceSettings(),
          ),
        );
      case 5:
        Navigator.push(
          context,
          NavigateToPageWidget(
             PetrolInServiceSettings(
               imageMemory: imageMemory!,
               textServiceScreen:textServiceScreen ,
             ),
          ),
        );
        break;
    }
  }
}
