import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../model/general_models/pages_model.dart';
import '../../../view/store_page/store_widgets/expansion_tile_widget.dart';
import '../../../view/store_page/store_widgets/general_widgets_in_store/function_add_to_opened_pages.dart';
import '../../../core/cubit/facility_cubit/facility_tab_cubit/facility_tab_cubit.dart';
import '../../../core/cubit/facility_cubit/facility_tab_cubit/facility_tab_state.dart';
import '../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../view/store_page/store_widgets/custom_add_button.dart';
import '../../../core/theming/assets.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../core/language/language_constant.dart';

class CustomAddButton extends StatelessWidget {
  const CustomAddButton({super.key, required this.text, required this.onTap, this.width});
final String text;
final double? width;
final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return    CustomContainer(
      isSelected: false,
      onTap:onTap,
      containerColor: AppColors.secondaryColor,
      containerWidth: width??162,
      containerHeight: 42,
      borderRadius: BorderRadius.circular(25),
      typeWidget: Row(
        children: [
          const Icon(
            Icons.add,
            color: AppColors.whiteColor,
            size: 28,
          ),
          TextInAppWidget(
            text: text,
            textSize: 16,
            textColor: AppColors.whiteColor,
            fontWeightIndex: FontSelectionData.boldFontFamily,
          ),
        ],
      ),
    );
  }
}
