import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/internal_orders/custom_widget/row_number_coin_widget.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';

class DesignProductOilWidget extends StatelessWidget {
  const DesignProductOilWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
      child: Column(
        spacing: 10,
        children: [
          TextInAppWidget(
            text: AppLanguageKeys.oils,
            textSize: 9,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.orangeColor,
          ),
          Image.asset(AppImageKeys.testOil),
          TextInAppWidget(
            text: 'أسم زيوت 1',
            textSize: 9,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: AppColors.greyColor,
          ),
          Row(
            spacing: 5,
            children: [
              TextInAppWidget(
                text: 'باقي 5 قطع',
                textSize: 9,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.blueColor,
              ),
              RowNumberCoinWidget(
                  numberText: '200', sizeText: 12, imageSrc: AppImageKeys.coin)
            ],
          )
        ],
      ),
    );
  }
}
