import 'package:flutter/material.dart';
import '../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../core/theming/assets.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';

class SelectDateWidget extends StatelessWidget {
  const SelectDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TextFormFieldWidget(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 10),
              textFormController: TextEditingController(),
              text: AppLanguageKeys.fromKey,
              textSize: 16,
              isColumn: true,
              textColor: AppColors.darkColor,
              borderColor: AppColors.darkGreyColor,
              //borderRadius: 20,
              fillColor: AppColors.whiteColor,
              textFormHeight: 35,
              hintText: '2020',
              suffixIcon: Icons.keyboard_arrow_down_outlined,
              suffixIconSize: 27,
              //suffixIconColor: AppColors.darkGreyColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            child: TextFormFieldWidget(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 10),
              textFormController: TextEditingController(),
              text:AppLanguageKeys.toKey,
              textSize: 16,
              isColumn: true,
              textColor: AppColors.darkColor,
              borderColor: AppColors.darkGreyColor,
              //borderRadius: 20,
              fillColor: AppColors.whiteColor,
              textFormHeight: 35,
              hintText: '2025',
              suffixIcon: Icons.keyboard_arrow_down_outlined,
              suffixIconSize: 27,
              //suffixIconColor: AppColors.darkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}
