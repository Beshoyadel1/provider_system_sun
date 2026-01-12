import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/other_data_data_container_in_list_data_add_spare_parts_in_service_settings.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/row_radio_button_in_data_container_in_list_data_add_spare_parts_in_service_settings.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/icon_car_orange_text_of_car_spare_parts_in_service_settings.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/first_row_data_container_in_list_data_add_spare_parts_in_service_settings.dart';

class DataContainerInListDataAddSparePartsInServiceSettings
    extends StatelessWidget {
  const DataContainerInListDataAddSparePartsInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FirstRowDataContainerInListDataAddSparePartsInServiceSettings(),
          IconCarOrangeTextOfCarSparePartsInServiceSettings(),
          RowRadioButtonInDataContainerInListDataAddSparePartsInServiceSettings(),
          OtherDataDataContainerInListDataAddSparePartsInServiceSettings(),
        ],
      ),
    );
  }
}
