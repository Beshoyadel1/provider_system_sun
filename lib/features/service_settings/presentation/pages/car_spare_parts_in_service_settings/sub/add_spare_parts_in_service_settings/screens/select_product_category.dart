import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_all_product_categories_cubit/get_all_product_categories_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_all_product_categories_cubit/get_all_product_categories_state.dart';
import 'product_form_widgets.dart';

class SelectProductCategory extends StatelessWidget {
  const SelectProductCategory({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GetAllProductCategoriesCubit, GetAllProductCategoriesState>(
        builder: (context, state) {
          final cubit = context.read<GetAllProductCategoriesCubit>();
          final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
          if (state is GetAllProductCategoriesLoading ||
              state is GetAllProductCategoriesInitial) {
            return ProductFieldLabel(
              label: AppLanguageKeys.productCategoryId,
              child: SizedBox(
                height: ProductFormStyle.fieldHeight(context),
                child: const Center(
                    child: SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.orangeColor),
                )),
              ),
            );
          }
          if (state is GetAllProductCategoriesError) {
            return ProductFieldLabel(
              label: AppLanguageKeys.productCategoryId,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.orangeColor),
                onPressed: cubit.getAllProductCategories,
                child: TextInAppWidget(
                  text: ar
                      ? 'تعذر تحميل الفئات، أعد المحاولة'
                      : 'Unable to load categories. Retry',
                  textSize: 12,
                  textColor: AppColors.orangeColor,
                ),
              ),
            );
          }
          return ProductDropdownField<int>(
            label: AppLanguageKeys.productCategoryId,
            value: cubit.selectedCategory?.id,
            items: [
              for (final category in cubit.categories)
                DropdownMenuItem(
                  value: category.id,
                  child: TextInAppWidget(
                      text: category.getName(context),
                      textSize: 13,
                      textColor: AppColors.darkColor,
                      maxLines: 1,
                      isEllipsisTextOverflow: true),
                )
            ],
            onChanged: (value) {
              if (value == null) return;
              cubit.selectCategory(cubit.categories
                  .firstWhere((category) => category.id == value));
            },
            validator: (value) => value == null
                ? (ar ? 'اختر فئة المنتج' : 'Select product category')
                : null,
          );
        },
      );
}
