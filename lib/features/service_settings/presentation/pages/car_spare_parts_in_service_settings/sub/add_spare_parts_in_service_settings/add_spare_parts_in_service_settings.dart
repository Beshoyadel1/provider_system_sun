import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/list_data_add_spare_parts_in_service_settings.dart';
import '../../../../../../../core/theming/colors.dart';

class AddSparePartsInServiceSettings extends StatelessWidget {
  final ProductModelGetProductsByCategory? product;

  const AddSparePartsInServiceSettings({
    super.key,
    this.product,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
      ),
      body:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: ListDataAddSparePartsInServiceSettings(
              product:product,
            ),
          ),
        ),
      ),
    );
  }
}