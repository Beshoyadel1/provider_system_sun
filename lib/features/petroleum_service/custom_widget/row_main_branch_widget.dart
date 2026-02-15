import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class RowMainBranchWidget extends StatelessWidget {
  final String? nameBranch, imagePath;

  const RowMainBranchWidget({super.key, this.nameBranch, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Image.asset(imagePath ?? AppImageKeys.branch),
        TextInAppWidget(
          text: nameBranch ?? 'فرع الرئيسي',
          textSize: 9,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.greyColor,
        ),
      ],
    );
  }
}
