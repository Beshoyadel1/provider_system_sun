import 'package:flutter/cupertino.dart';
import '../../../../../../features/internal_orders/custom_widget/select_time_profit_service_widget.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class PartOfCategoryAndOffers extends StatelessWidget {
  const PartOfCategoryAndOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: AppLanguageKeys.link,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),
        SelectTimeProfitServiceWidget(
          hint: AppLanguageKeys.category,
          options: [
            'تصنيف 1',
            'تصنيف 2',
            'تصنيف 3',
          ],
          backGroundColor: AppColors.whiteColor,
          textColor: AppColors.greyColor,
          borderColor: AppColors.greyColor,
          width: 250,
        ),
        SelectTimeProfitServiceWidget(
          hint: AppLanguageKeys.storeOffers,
          options: [
            'عروض المتجر 1',
            'عروض المتجر 2',
            'عروض المتجر 3',
          ],
          backGroundColor: AppColors.whiteColor,
          textColor: AppColors.greyColor,
          borderColor: AppColors.greyColor,
          width: 250,
        ),
      ],
    );
  }
}
