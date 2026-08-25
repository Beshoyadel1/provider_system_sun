import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';

class PermissionsAndServicesProvidedToTheUserText extends StatelessWidget {
  final String? text;
  const PermissionsAndServicesProvidedToTheUserText({super.key,this.text});

  @override
  Widget build(BuildContext context) {
    return TextInAppWidget(
      text: text??AppLanguageKeys.permissionsFromServices,
      textSize: 16,
      fontWeightIndex: FontSelectionData.mediumFontFamily,
      textColor: AppColors.blackColor,
    );
  }
}
