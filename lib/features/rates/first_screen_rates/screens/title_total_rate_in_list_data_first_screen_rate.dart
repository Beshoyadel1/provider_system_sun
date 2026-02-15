import 'package:flutter/cupertino.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class TitleTotalRateInListDataFirstScreenRate extends StatelessWidget {
  const TitleTotalRateInListDataFirstScreenRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Flexible(
          child: TextInAppWidget(
            text: AppLanguageKeys.totalReviews,
            textSize: 16,
            fontWeightIndex: FontSelectionData.mediumFontFamily,
            textColor: AppColors.blackColor,
          ),
        ),
        Row(
          spacing: 5,
          children: [
            Image.asset(AppImageKeys.star11),
            TextInAppWidget(
              text: '4.0',
              textSize: 22,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.blackColor,
            ),
          ],
        )
      ],
    );
  }
}
