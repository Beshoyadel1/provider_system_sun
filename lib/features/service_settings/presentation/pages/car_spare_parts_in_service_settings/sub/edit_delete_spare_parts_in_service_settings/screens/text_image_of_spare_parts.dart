import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class TextImageOfSpareParts extends StatelessWidget {
  const TextImageOfSpareParts({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        TextInAppWidget(
          text: 'نيسان',
          textSize: 16,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.greyColor,
        ),
        Image.asset(AppImageKeys.logo11)
      ],
    );
  }
}
