import 'package:flutter/material.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import 'login_button_widget.dart';
import 'password_widget.dart';
import 'user_name_widget.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: AppLanguageKeys.loginKey,
          textSize: 20,
          fontWeightIndex: FontSelectionData.boldFontFamily,
        ),
        TextInAppWidget(
          text: AppLanguageKeys.enterPhoneAndPasswordKey,
          textSize: 18,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.darkColor,
        ),
        UserNameWidget(),
        PasswordWidget(),
        SizedBox(
          height: 10,
        ),
        TextInAppWidget(
          text: AppLanguageKeys.forgotPasswordKey,
          textSize: 14,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.darkColor,
        ),
        LoginButtonWidget(text: AppLanguageKeys.loginKey),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
