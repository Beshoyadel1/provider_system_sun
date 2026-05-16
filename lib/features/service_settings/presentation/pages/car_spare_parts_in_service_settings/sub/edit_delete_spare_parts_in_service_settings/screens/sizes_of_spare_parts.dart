import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/section_card.dart';
import '../../../../../../../../core/theming/colors.dart';


class SizesOfSpareParts extends StatelessWidget {
  final List<ProductSizeModel> sizes;

  const SizesOfSpareParts({
    super.key,
    required this.sizes,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic =
        LanguageCubit.get(context).isAllAppLanguageArabic;

    return SectionCard(
      title: isArabic ? 'الأحجام' : 'Sizes',
      child: sizes.isEmpty
          ? Text(isArabic
          ? 'لا يوجد أحجام'
          : 'No sizes available')
          : Column(
        children: sizes.map((size) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                /// 🔹 Size Name
                Expanded(
                  child: Text(
                    isArabic
                        ? (size.name ?? "")
                        : (size.latinName ?? ""),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// 🔥 Price + Cost Column
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Price: ${size.price ?? 0}",
                      style: TextStyle(
                        color: AppColors.orangeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Cost: ${size.cost ?? 0}",
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}