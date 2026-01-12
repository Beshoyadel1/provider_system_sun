import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/data_of_specific_category.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/logic/select_category_add_Spare_Parts_cubit.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/logic/select_category_add_Spare_Parts_state.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class RowRadioButtonInDataContainerInListDataAddSparePartsInServiceSettings
    extends StatelessWidget {
  const RowRadioButtonInDataContainerInListDataAddSparePartsInServiceSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectCategoryAddSparePartsCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<SelectCategoryAddSparePartsCubit,
              SelectCategoryAddSparePartsState>(
            buildWhen: (previous, current) =>
                previous.selectedOption != current.selectedOption,
            builder: (context, state) {
              return Row(
                spacing: 10,
                children: [
                  Flexible(
                    child: RadioListTile<int>(
                      activeColor: AppColors.orangeColor,
                      title: Opacity(
                        opacity: state.selectedOption == 0 ? 1 : 0.5,
                        child: TextInAppWidget(
                            text: AppLanguageKeys.allCategoriesIncluded,
                            textSize: 13,
                            fontWeightIndex: FontSelectionData.mediumFontFamily,
                            textColor: AppColors.darkColor),
                      ),
                      value: 0,
                      groupValue: state.selectedOption,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        context
                            .read<SelectCategoryAddSparePartsCubit>()
                            .changeOption(value!);
                      },
                    ),
                  ),
                  Flexible(
                    child: RadioListTile<int>(
                      activeColor: AppColors.orangeColor,
                      title: Opacity(
                        opacity: state.selectedOption == 1 ? 1 : 0.5,
                        child: TextInAppWidget(
                          text: AppLanguageKeys.specificCategory,
                          textSize: 13,
                          fontWeightIndex: FontSelectionData.mediumFontFamily,
                          textColor: AppColors.darkColor,
                        ),
                      ),
                      value: 1,
                      groupValue: state.selectedOption,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        context
                            .read<SelectCategoryAddSparePartsCubit>()
                            .changeOption(value!);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          BlocBuilder<SelectCategoryAddSparePartsCubit,
              SelectCategoryAddSparePartsState>(
            buildWhen: (previous, current) =>
                previous.selectedOption != current.selectedOption,
            builder: (context, state) {
              if (state.selectedOption == 1) {
                return DataOfSpecificCategory();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
