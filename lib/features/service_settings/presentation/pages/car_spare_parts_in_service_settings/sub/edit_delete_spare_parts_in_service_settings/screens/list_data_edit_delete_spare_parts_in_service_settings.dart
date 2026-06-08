import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/data_container_in_list_data_edit_delete_spare_parts_in_service_settings.dart';
import '../../../../../../../../core/theming/colors.dart';

class ListDataEditDeleteSparePartsInServiceSettings extends StatelessWidget {
  final ProductModelGetProductsByCategory product;

  const ListDataEditDeleteSparePartsInServiceSettings({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DataContainerInListDataEditDeleteSparePartsInServiceSettings(
        product: product,
      ),
    );
  }
}