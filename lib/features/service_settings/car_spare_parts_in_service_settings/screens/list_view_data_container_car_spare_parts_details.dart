import 'package:flutter/cupertino.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/mobile_list_view_data_container_car_spare_parts_details.dart';
import '../../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/tab_list_view_data_container_car_spare_parts_details.dart';
import '../../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/web_list_view_data_container_car_spare_parts_details.dart';

class ListViewDataContainerCarSparePartsDetails extends StatelessWidget {
  const ListViewDataContainerCarSparePartsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTab = size.width > ValuesOfAllApp.mobileWidth && size.width <= 1190;
    bool isWeb = size.width > 1190;
    return isWeb
        ? WebListViewDataContainerCarSparePartsDetails()
        : isTab
            ? TabListViewDataContainerCarSparePartsDetails()
            : MobileListViewDataContainerCarSparePartsDetails();
  }
}
