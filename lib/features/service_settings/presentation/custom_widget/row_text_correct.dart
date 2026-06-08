import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../core/theming/assets.dart';

class RowTextCorrect extends StatelessWidget {
  final String text;

  const RowTextCorrect({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: const BoxDecoration(
            color: AppColors.greenColor,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              color: AppColors.whiteColor,
              size: 10,
            ),
          ),
        ),
        TextInAppWidget(
          text: text,
          textSize: 10,
          fontWeightIndex: FontSelectionData.mediumFontFamily,
          textColor: AppColors.darkColor,
        ),
      ],
    );
  }
}
