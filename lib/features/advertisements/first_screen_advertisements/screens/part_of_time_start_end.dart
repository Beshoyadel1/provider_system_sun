import 'package:flutter/cupertino.dart';
import '../../../../../../features/internal_orders/custom_widget/select_time_profit_service_widget.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class PartOfTimeStartEnd extends StatelessWidget {
  const PartOfTimeStartEnd({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: AppLanguageKeys.durationFromTo,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),
        SelectTimeProfitServiceWidget(
          hint: '00/00/0000',
          isTime: true,
          backGroundColor: AppColors.whiteColor,
          textColor: AppColors.greyColor,
          borderColor: AppColors.greyColor,
          width: 250,
        ),
        SelectTimeProfitServiceWidget(
          hint: '00/00/0000',
          isTime: true,
          backGroundColor: AppColors.whiteColor,
          textColor: AppColors.greyColor,
          borderColor: AppColors.greyColor,
          width: 250,
        ),
      ],
    );
  }
}
