import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/other_data_data_container_in_list_data_add_spare_parts_in_service_settings.dart';

class DataContainerInListDataAddSparePartsInServiceSettings
    extends StatelessWidget {
  final ProductModelGetProductsByCategory? product;

  const DataContainerInListDataAddSparePartsInServiceSettings({
    super.key,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OtherDataDataContainerInListDataAddSparePartsInServiceSettings(
            product: product,
          ),
        ],
      ),
    );
  }
}