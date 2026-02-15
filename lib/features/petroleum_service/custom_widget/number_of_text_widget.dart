import 'package:flutter/cupertino.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class NumberOfTextWidget extends StatelessWidget {
  final String? numberText;
  final Color? textColorNumberText;
  final double? textSizeNumberText;

  const NumberOfTextWidget(
      {super.key,
      this.numberText,
      this.textColorNumberText,
      this.textSizeNumberText});

  @override
  Widget build(BuildContext context) {
    return TextInAppWidget(
      text: numberText ?? '1#',
      textSize: textSizeNumberText ?? 15,
      fontWeightIndex: FontSelectionData.regularFontFamily,
      textColor: textColorNumberText ?? AppColors.blackColor,
    );
  }
}
