import 'package:flutter/material.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'data_container_in_list_data_add_spare_parts_in_service_settings.dart';

class ListDataAddSparePartsInServiceSettings extends StatelessWidget {
  const ListDataAddSparePartsInServiceSettings({super.key, this.product});
  final ProductModelGetProductsByCategory? product;
  @override
  Widget build(BuildContext context) =>
      DataContainerInListDataAddSparePartsInServiceSettings(product: product);
}
