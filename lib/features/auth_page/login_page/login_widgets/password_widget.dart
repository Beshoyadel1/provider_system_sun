import 'package:flutter/material.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({super.key, this.text,required this.controller});
  final TextEditingController controller;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextFormFieldWidget(
        textFormController: controller,
        text: text ?? AppLanguageKeys.passwordKey,
        isColumn: true,
        textColor: AppColors.darkColor,
        fillColor: AppColors.whiteColor,
        textSize: 17,
        fontWeightIndex: FontSelectionData.boldFontFamily,
        borderColor: AppColors.lightGreyColor,
        enabledBorderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
