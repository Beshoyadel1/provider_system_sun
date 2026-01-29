import 'package:flutter/material.dart';
import '../../../../../../core/pages_widgets/button_widget.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/colors.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({super.key, required this.text, this.onPressed});
  final VoidCallback? onPressed;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withAlpha(40),
            blurRadius: 22,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ButtonWidget(
        text: text,
        textSize: 17,
        textColor: AppColors.whiteColor,
        fontWeightIndex: FontSelectionData.boldFontFamily,
        buttonColor: AppColors.orangeColor,
        borderRadius: 24,
        onTap: onPressed,
      ),
    );
  }
}
