import 'package:flutter/cupertino.dart';
import '../../../../../../../../features/service_settings/custom_widget/Container_number_widget.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class SizesOfSpareParts extends StatelessWidget {
  const SizesOfSpareParts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInAppWidget(
              text: AppLanguageKeys.sizesOrDimensions,
              textSize: 16,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.darkColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                ContainerNumberWidget(
                  textNumber: '1',
                ),
                ContainerNumberWidget(
                  textNumber: '2',
                ),
                ContainerNumberWidget(
                  textNumber: '3',
                )
              ],
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInAppWidget(
              text: AppLanguageKeys.availableQuantity,
              textSize: 16,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.darkColor,
            ),
            Row(
              spacing: 10,
              children: [
                ContainerNumberWidget(
                  textNumber: '1',
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
