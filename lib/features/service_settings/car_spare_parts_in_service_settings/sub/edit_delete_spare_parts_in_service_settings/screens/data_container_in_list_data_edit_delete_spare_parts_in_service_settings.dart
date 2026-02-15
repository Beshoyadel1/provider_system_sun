import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/sizes_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/categories_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/text_image_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/price_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/text_description_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/first_row_in_data_container_in_list_data_edit_delete_spare_parts_in_service_settings.dart';

class DataContainerInListDataEditDeleteSparePartsInServiceSettings
    extends StatelessWidget {
  const DataContainerInListDataEditDeleteSparePartsInServiceSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FirstRowInDataContainerInListDataEditDeleteSparePartsInServiceSettings(),
          TextDescriptionOfSpareParts(),
          PriceOfSpareParts(),
          TextImageOfSpareParts(),
          CategoriesOfSpareParts(),
          SizesOfSpareParts()
        ],
      ),
    );
  }
}
