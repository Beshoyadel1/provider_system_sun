import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';

class UserNameWidget extends StatelessWidget {
  const UserNameWidget({
    super.key,
    required this.controller,
    this.text,
    this.isEmail = false,
    this.isPhoneNumber = false,
  });

  final TextEditingController controller;
  final String? text;

  final bool isEmail;
  final bool isPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextFormFieldWidget(
        textFormController: controller,
        isValidator: true,
        text: text ?? AppLanguageKeys.phoneNumberKey,
        isColumn: true,
        textColor: AppColors.darkColor,
        fillColor: AppColors.whiteColor,
        textSize: 16,
        fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        borderColor: AppColors.lightGreyColor,
        enabledBorderRadius:
        const BorderRadius.all(Radius.circular(10)),
        isDigit: isPhoneNumber,
        inputFormatters: isEmail
            ? [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ]
            : null,
      ),
    );
  }
}
