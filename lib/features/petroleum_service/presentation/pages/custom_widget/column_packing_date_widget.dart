import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class ColumnPackingDateWidget extends StatelessWidget {
  final String? title, subTitle;

  const ColumnPackingDateWidget({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: title ?? 'تاريخ التعبئة',
          textSize: 9,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.greyColor,
        ),
        TextInAppWidget(
          text: subTitle ?? '1:00 pm _1/1/2025',
          textSize: 12,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.darkColor,
        )
      ],
    );
  }
}
