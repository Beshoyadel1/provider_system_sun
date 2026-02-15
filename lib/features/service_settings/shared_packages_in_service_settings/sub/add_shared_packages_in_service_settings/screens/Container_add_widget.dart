import 'package:flutter/cupertino.dart';
import '../../../../../../../../core/theming/colors.dart';
import '../../../../../../../../core/theming/fonts.dart';
import '../../../../../../../../core/theming/text_styles.dart';

class ContainerAddWidget extends StatelessWidget {
  final String text;
  final Color? colorBackGround, colorText;

  const ContainerAddWidget(
      {super.key, required this.text, this.colorBackGround, this.colorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      decoration: BoxDecoration(
        color: colorBackGround ?? AppColors.blackColor44,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
      ),
      child: TextInAppWidget(
        text: text,
        textSize: 11,
        fontWeightIndex: FontSelectionData.regularFontFamily,
        textColor: colorText ?? AppColors.whiteColor,
        textAlign: TextAlign.center,
      ),
    );
  }
}
