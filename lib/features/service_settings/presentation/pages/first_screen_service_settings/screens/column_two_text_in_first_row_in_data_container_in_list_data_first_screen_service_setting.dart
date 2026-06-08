import 'package:flutter/cupertino.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class ColumnTwoTextInFirstRowInDataContainerInListDataFirstScreenServiceSetting
    extends StatelessWidget {
  final String? text1, text2;

  const ColumnTwoTextInFirstRowInDataContainerInListDataFirstScreenServiceSetting(
      {super.key, this.text1, this.text2});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          TextInAppWidget(
            text: text1 ?? AppLanguageKeys.nissanServiceSettings,
            textSize: 13,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.blackColor,
          ),
          TextInAppWidget(
            text: text2 ?? AppLanguageKeys.serviceSettingsDetails,
            textSize: 11,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.blackColor,
          )
        ],
      ),
    );
  }
}
