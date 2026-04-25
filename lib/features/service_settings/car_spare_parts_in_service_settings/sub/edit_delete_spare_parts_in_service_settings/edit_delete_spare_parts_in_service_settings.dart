import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/api_functions/product/get_products_by_category_model/product_model_get_products_by_category.dart';
import '../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/list_data_edit_delete_spare_parts_in_service_settings.dart';
import '../../../../../../../core/theming/colors.dart';

class EditDeleteSparePartsInServiceSettings extends StatelessWidget {
  final ProductModelGetProductsByCategory product;

  const EditDeleteSparePartsInServiceSettings({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: ListDataEditDeleteSparePartsInServiceSettings(
                      product:product,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
