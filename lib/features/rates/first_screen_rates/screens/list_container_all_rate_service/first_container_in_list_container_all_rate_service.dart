import 'package:flutter/cupertino.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class FirstContainerInListContainerAllRateService extends StatelessWidget {
  const FirstContainerInListContainerAllRateService({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.orangeColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextInAppWidget(
          text: AppLanguageKeys.allReviews,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.whiteColor,
        ),
      ),
    );
  }
}
