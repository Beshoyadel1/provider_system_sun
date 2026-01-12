import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/utilies/line_chart_function.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../store_page/store_widgets/car_model_widget/widgets/select_date_widget.dart';

class ProfitsServices extends StatelessWidget {
  const ProfitsServices({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        containerWidth: 375,
        borderRadius: BorderRadius.circular(12),
        isSelected: false,
        onTap: () {},
        typeWidget: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextInAppWidget(
                    text: AppLanguageKeys.internalServicesProfitKey,
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                  ),
                  TextInAppWidget(
                    text: AppLanguageKeys.priceKey,
                    textSize: 16,
                    fontWeightIndex: FontSelectionData.regularFontFamily,
                    textColor: AppColors.orangeColor,
                  ),
                ],
              ),
              const SelectDateWidget(),
              AspectRatio(
                aspectRatio: 2.2,
                child: LineChart(sampleData(
                    colorGradient1: AppColors.orangeColor,
                    colorGradient2: AppColors.orangeColor.withAlpha(80),
                    colorGradient3: AppColors.orangeColor.withAlpha(0))),
              ),
              const SizedBox(
                height: 10,
              ),
            ]));
  }
}
