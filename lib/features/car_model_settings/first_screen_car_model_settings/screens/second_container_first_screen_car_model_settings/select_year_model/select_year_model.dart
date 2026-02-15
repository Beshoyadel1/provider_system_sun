import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/internal_orders/custom_widget/select_time_profit_service_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class SelectYearModel extends StatelessWidget {
  const SelectYearModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Flexible(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInAppWidget(
                text: AppLanguageKeys.from,
                textSize: 13,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.blackColor,
              ),
              SelectTimeProfitServiceWidget(
                hint: '',
                backGroundColor: AppColors.whiteColor,
                textColor: AppColors.greyColor,
                borderColor: AppColors.greyColor,
                width: 250,
                options: ['2000', '2001', '2002', '2003', '2004', '2005'],
              ),
            ],
          ),
        ),
        Flexible(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInAppWidget(
                text: AppLanguageKeys.to,
                textSize: 13,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.blackColor,
              ),
              SelectTimeProfitServiceWidget(
                hint: '',
                backGroundColor: AppColors.whiteColor,
                textColor: AppColors.greyColor,
                borderColor: AppColors.greyColor,
                width: 250,
                options: ['2000', '2001', '2002', '2003', '2004', '2005'],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
