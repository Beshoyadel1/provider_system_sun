import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/api_functions/product/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/section_card.dart';

class BrandOfSpareParts extends StatelessWidget {
  final List<BrandModel> brands;

  const BrandOfSpareParts({
    super.key,
    required this.brands,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: AppLanguageKeys.selectCarBrand,
      child: brands.isEmpty
          ? const Text('No brands available')
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: brands.map((brand) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand.getBrandName(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                if (brand.models.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: brand.models.map((model) {
                      return Chip(
                        label: Text(model.modelName ?? ""),
                        backgroundColor:
                        AppColors.orangeColor.withOpacity(0.1),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}