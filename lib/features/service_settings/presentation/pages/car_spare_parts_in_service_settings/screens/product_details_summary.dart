import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/memory_image_with_fallback.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';

class ProductDetailsSummary extends StatelessWidget {
  final ProductModelGetProductsByCategory product;
  const ProductDetailsSummary({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    final heading = Column(
      key: const ValueKey('product-details-heading'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: product.getName(context),
          textSize: 18,
          textColor: AppColors.darkColor,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 16, runSpacing: 8, children: [
          _fact('${ar ? 'رقم المنتج' : 'Product ID'}: ${product.id}'),
          _fact('${ar ? 'السعر' : 'Price'}: ${product.price ?? 0}',
              color: AppColors.blueColor),
          _fact('${ar ? 'التكلفة' : 'Cost'}: ${product.cost ?? 0}',
              color: AppColors.blueColor),
          if (product.category != null)
            _fact(product.category!.getName(context),
                color: AppColors.orangeColor),
        ]),
      ],
    );
    final description = product.getDescription(context);
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description.isNotEmpty) ...[
          const SizedBox(height: 12),
          _fact(description, color: AppColors.darkColor),
        ],
        if (product.instructions?.isNotEmpty == true) ...[
          const SizedBox(height: 10),
          _fact(
              '${ar ? 'التعليمات' : 'Instructions'}: ${product.instructions}'),
        ],
        if (product.brands.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final brand in product.brands)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                  border: Border.all(color: AppColors.cardStroke),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextInAppWidget(
                  text: [
                    brand.getBrandName(context),
                    ...brand.models.map((model) => model.modelName ?? ''),
                  ].where((name) => name.isNotEmpty).join(' / '),
                  textSize: 12,
                  textColor: AppColors.darkGreyColor,
                ),
              ),
          ]),
        ],
      ],
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 600;
        final imageSide = wide ? 148.0 : 96.0;
        final image = Container(
          key: const ValueKey('product-details-image'),
          width: imageSide,
          height: imageSide,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.scaffoldColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.cardStroke),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: MemoryImageWithFallback(
              bytes: product.image,
              fit: BoxFit.contain,
              fallback: const Center(
                child: Icon(Icons.inventory_2_outlined,
                    color: AppColors.greyColor, size: 40),
              ),
            ),
          ),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [heading, if (wide) details],
                  ),
                ),
              ],
            ),
            if (!wide) details,
          ],
        );
      }),
    );
  }

  Widget _fact(String text, {Color color = AppColors.darkGreyColor}) =>
      TextInAppWidget(text: text, textSize: 13, textColor: color);
}
