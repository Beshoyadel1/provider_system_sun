import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../features/internal_orders/custom_widget/select_time_profit_service_widget.dart';

class FirstRowDataContainerDesignDigramForPetroleum extends StatelessWidget {
  const FirstRowDataContainerDesignDigramForPetroleum({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        TextInAppWidget(
          text: AppLanguageKeys.fuelFillingSalesPerBranch,
          textSize: 22,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.blackColor,
        ),
        Row(
          spacing: 10,
          children: [
            TextInAppWidget(
              text: AppLanguageKeys.from,
              textSize: 15,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.blackColor,
            ),
            Flexible(
              child: SelectTimeProfitServiceWidget(
                hint: '00/00/0000',
                textColor: AppColors.blackColor,
                backGroundColor: AppColors.whiteColor,
                borderColor: AppColors.greyColor,
                isTime: true,
              ),
            ),
            TextInAppWidget(
              text: AppLanguageKeys.to,
              textSize: 15,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.blackColor,
            ),
            Flexible(
              child: SelectTimeProfitServiceWidget(
                hint: '00/00/0000',
                textColor: AppColors.blackColor,
                backGroundColor: AppColors.whiteColor,
                borderColor: AppColors.greyColor,
                isTime: true,
              ),
            )
          ],
        )
      ],
    );
  }
}
