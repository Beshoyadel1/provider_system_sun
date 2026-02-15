import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class ContainerDetailsWidget extends StatelessWidget {
  final String? title;
  final void Function()? onTap;
  final Color? backGroundColor, textColor, borderColor;

  const ContainerDetailsWidget(
      {super.key,
      this.onTap,
      this.title,
      this.textColor,
      this.borderColor,
      this.backGroundColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: backGroundColor ?? AppColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: borderColor ?? AppColors.orangeColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: TextInAppWidget(
            text: title ?? AppLanguageKeys.details,
            textSize: 12,
            fontWeightIndex: FontSelectionData.regularFontFamily,
            textColor: textColor ?? AppColors.orangeColor,
          ),
        ),
      ),
    );
  }
}
