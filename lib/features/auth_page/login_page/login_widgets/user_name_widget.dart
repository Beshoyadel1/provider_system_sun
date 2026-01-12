import 'package:flutter/material.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';

class UserNameWidget extends StatelessWidget {
  const UserNameWidget({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextFormFieldWidget(
        textFormController: TextEditingController(),
        text: text ?? AppLanguageKeys.phoneNumberKey,
        isColumn: true,
        textColor: AppColors.darkColor,
        fillColor: AppColors.whiteColor,
        textSize: 16,
        fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        borderColor: AppColors.lightGreyColor,
        enabledBorderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
