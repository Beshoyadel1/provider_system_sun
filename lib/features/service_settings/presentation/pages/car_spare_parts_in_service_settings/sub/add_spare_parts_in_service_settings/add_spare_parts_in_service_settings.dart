import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'screens/list_data_add_spare_parts_in_service_settings.dart';
import 'screens/product_form_widgets.dart';

class AddSparePartsInServiceSettings extends StatelessWidget {
  const AddSparePartsInServiceSettings({super.key, this.product});
  final ProductModelGetProductsByCategory? product;

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        foregroundColor: AppColors.darkColor,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        title: TextInAppWidget(
          text: product == null
              ? (ar ? 'إضافة منتج' : 'Add product')
              : (ar ? 'تعديل منتج' : 'Edit product'),
          textSize: 17,
          textColor: AppColors.darkColor,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        ),
      ),
      body: Theme(
        data: ProductFormStyle.theme(context),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 600 ? 12 : 20,
                  vertical: 16),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child:
                      ListDataAddSparePartsInServiceSettings(product: product),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
