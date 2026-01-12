import 'package:flutter/material.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';

class SelectModelCarTextImageOrangeLineWidget extends StatelessWidget {
  final String imagePath, text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectModelCarTextImageOrangeLineWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.orangeColor : AppColors.transparent,
            width: isSelected ? 1 : 0,
          ),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.whiteColor,
        ),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 50),
            TextInAppWidget(
              text: text,
              textSize: 12,
              fontWeightIndex: FontSelectionData.mediumFontFamily,
              textColor: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
