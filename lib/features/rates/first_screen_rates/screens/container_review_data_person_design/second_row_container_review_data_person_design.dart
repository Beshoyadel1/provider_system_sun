import 'package:flutter/cupertino.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class SecondRowContainerReviewDataPersonDesign extends StatelessWidget {
  final String textReview;

  const SecondRowContainerReviewDataPersonDesign(
      {super.key, required this.textReview});

  @override
  Widget build(BuildContext context) {
    return TextInAppWidget(
      text: textReview,
      textSize: 10,
      fontWeightIndex: FontSelectionData.regularFontFamily,
      textColor: AppColors.blackColor,
    );
  }
}
