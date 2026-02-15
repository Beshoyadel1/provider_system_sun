import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class RowNameEmpWidget extends StatelessWidget {
  final String? title, subTitle, imagePath;
  final Color? textColorTitle, textColorSubTitle;
  final double? textSizeTitle, textSizeSubTitle;

  const RowNameEmpWidget(
      {super.key,
      this.title,
      this.subTitle,
      this.imagePath,
      this.textColorSubTitle,
      this.textColorTitle,
      this.textSizeSubTitle,
      this.textSizeTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Image.asset(imagePath ?? AppImageKeys.person22),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            TextInAppWidget(
              text: title ?? 'أسم العامل',
              textSize: textSizeTitle ?? 9,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: textColorTitle ?? AppColors.greyColor,
            ),
            TextInAppWidget(
              text: subTitle ?? 'أحمد محمود',
              textSize: textSizeSubTitle ?? 12,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: textColorSubTitle ?? AppColors.darkColor,
            )
          ],
        )
      ],
    );
  }
}
