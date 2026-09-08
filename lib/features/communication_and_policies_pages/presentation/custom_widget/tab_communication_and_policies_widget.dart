import 'package:flutter/material.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';

class TabCommunicationAndPoliciesWidget extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback? onTap;

  const TabCommunicationAndPoliciesWidget(
      {super.key, required this.isSelected, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.orangeColor : AppColors.greyColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: AppFonts.readexProFontFamily,
          ),
        ),
      ),
    );
  }
}
