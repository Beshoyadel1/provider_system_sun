import 'package:flutter/cupertino.dart';
import '../../../../../core/api_functions/general/services/get_services_model/service_setting_model.dart';
import '../../../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../../../core/utilies/map_of_all_app.dart';

class ServiceSettingsHelper {
  static List<ServiceSettingModel> filterByParentId({
    required List<ServiceSettingModel> services,
    required int parentId,
  }) {
    return services
        .where((e) => e.parentId == parentId)
        .toList();
  }

  static String getServiceName({
    required ServiceSettingModel service,
    required bool isArabic,
  }) {
    return isArabic
        ? service.name ?? ''
        : service.latinName ?? '';
  }

  static void handleNavigation(BuildContext context, int? id) {
    switch (id) {
      case 1:
        AppCubit.get(context).navigateToPage(
          PagesOfAllApp.maintenanceAndInteriorServicesPageNumber,
        );
        break;

      case 2:
        AppCubit.get(context).navigateToPage(
          PagesOfAllApp.mobileServicesAndTransportationPageNumber,
        );
        break;

      case 3:
        AppCubit.get(context).navigateToPage(
          PagesOfAllApp.carPartsPageNumber,
        );
        break;

      case 4:
        AppCubit.get(context).navigateToPage(
          PagesOfAllApp.sharedPackagesPageNumber,
        );
      case 5:
        AppCubit.get(context).navigateToPage(
          PagesOfAllApp.petrolInServiceSettingPageNumber,
        );
        break;
    }
  }
}