import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/list_view_data_container_car_spare_parts_details.dart';
import '../../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/icon_car_orange_text_of_car_spare_parts_in_service_settings.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/first_row_in_data_container_in_list_data_first_screen_service_setting.dart';

class DataContainerInListDataCarSparePartsInServiceSettings
    extends StatelessWidget {
  const DataContainerInListDataCarSparePartsInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FirstRowInDataContainerInListDataFirstScreenServiceSetting(),
          IconCarOrangeTextOfCarSparePartsInServiceSettings(),
          ListViewDataContainerCarSparePartsDetails()
        ],
      ),
    );
  }
}
