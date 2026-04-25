import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/api_functions/product/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/brand_of_spare_parts.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/cost_of_spare_parts.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/stock_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/sizes_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/categories_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/text_image_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/price_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/text_description_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/first_row_in_data_container_in_list_data_edit_delete_spare_parts_in_service_settings.dart';

class DataContainerInListDataEditDeleteSparePartsInServiceSettings
    extends StatelessWidget {
  final ProductModelGetProductsByCategory product;

  const DataContainerInListDataEditDeleteSparePartsInServiceSettings({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FirstRowInDataContainerInListDataEditDeleteSparePartsInServiceSettings(
          nameCategory: product.category?.getName(context) ?? "",
          imageProduct: product.image,
          nameProduct: product.getName(context),
        ),
        TextDescriptionOfSpareParts(
          description: product.getDescription(context),
        ),
        PriceOfSpareParts(
          price: (product.price ?? 0).toString(),
        ),
        CostOfSpareParts(cost: (product.cost ?? 0).toString()),
        StockOfSpareParts(stock: product.inStock.toString()),
        CategoriesOfSpareParts(
          categoryName: product.category?.getName(context) ?? "",
        ),
        BrandOfSpareParts(
          brands: product.brands,
        ),
        SizesOfSpareParts(
          sizes: product.sizes,
        ),
      ],
    );
  }
}
