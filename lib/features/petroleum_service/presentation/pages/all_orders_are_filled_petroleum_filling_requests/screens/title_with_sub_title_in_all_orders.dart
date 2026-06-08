import 'package:flutter/cupertino.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class TitleWithSubTitleInAllOrders extends StatelessWidget {
  final String? title, subTitle;

  const TitleWithSubTitleInAllOrders({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: title ?? AppLanguageKeys.allFillingOrders,
          textSize: 15,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),
        TextInAppWidget(
          text: subTitle ?? AppLanguageKeys.newRequestsList,
          textSize: 13,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.greyColor,
        )
      ],
    );
  }
}
