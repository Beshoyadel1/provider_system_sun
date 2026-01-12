import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class TitleSelectYearModel extends StatelessWidget {
  const TitleSelectYearModel({super.key});

  @override
  Widget build(BuildContext context) {
    return TextInAppWidget(
      text: AppLanguageKeys.selectModelYears,
      textSize: 18,
      fontWeightIndex: FontSelectionData.regularFontFamily,
      textColor: AppColors.greyColor,
    );
  }
}
