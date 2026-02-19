import 'package:flutter/cupertino.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class FirstContainerInListContainerAllRateService extends StatelessWidget {
  const FirstContainerInListContainerAllRateService({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Container(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.orangeColor,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const TextInAppWidget(
          text: AppLanguageKeys.allReviews,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.whiteColor,
        ),
      ),
    );
  }
}
