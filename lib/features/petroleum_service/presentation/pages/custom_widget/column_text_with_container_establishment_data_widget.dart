import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/theming/fonts.dart';
import '../../../../../../../core/theming/text_styles.dart';

class ColumnTextWithContainerEstablishmentDataWidget extends StatelessWidget {
  final String text, textContainer;
  final void Function()? onTap;

  const ColumnTextWithContainerEstablishmentDataWidget(
      {super.key, required this.text, required this.textContainer, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 7,
      children: [
        TextInAppWidget(
          text: text,
          textSize: 12,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.blackColor,
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsetsGeometry.symmetric(vertical: 7),
            width: 150,
            decoration: BoxDecoration(
              color: AppColors.blackColor44,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInAppWidget(
                  text: textContainer,
                  textSize: 12,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  textColor: AppColors.whiteColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
