import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_all_product_categories_cubit/get_all_product_categories_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_all_product_categories_cubit/get_all_product_categories_state.dart';

class SelectProductCategory extends StatelessWidget {
  const SelectProductCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.productCategoryId,
          textSize: 11,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),

        BlocBuilder<GetAllProductCategoriesCubit,
            GetAllProductCategoriesState>(
          builder: (context, state) {
            final cubit =
            context.read<GetAllProductCategoriesCubit>();

            if (state is GetAllProductCategoriesLoading) {
              return const CircularProgressIndicator();
            }

            if (state is GetAllProductCategoriesSuccess) {
              return SizedBox(
                height: 35,
                child: DropdownButtonFormField<int>(
                  isDense: true,
                  value: cubit.selectedCategory?.id,

                  items: cubit.categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: TextInAppWidget(
                        text: category.getName(context),
                        textSize: 13,
                        fontWeightIndex:
                        FontSelectionData.regularFontFamily,
                        textColor: AppColors.blackColor,
                      ),
                    );
                  }).toList(),

                  onChanged: (value) {
                    final selected = cubit.categories.firstWhere(
                          (e) => e.id == value,
                    );

                    cubit.selectCategory(selected);
                  },

                  validator: (value) {
                    if (value == null) return '';
                    return null;
                  },

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.transparent,
                    contentPadding: const EdgeInsets.all(5),

                    errorStyle: const TextStyle(
                      height: 0.01,
                      fontSize: 1,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color:
                        AppColors.darkColor.withOpacity(0.2),
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color:
                        AppColors.darkColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: AppColors.redColor),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.redColor,
                        width: 1.5,
                      ),
                    ),
                  ),

                  icon: const Icon(Icons.arrow_drop_down),
                ),
              );
            }

            if (state is GetAllProductCategoriesError) {
              return const Text("Error loading categories");
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}