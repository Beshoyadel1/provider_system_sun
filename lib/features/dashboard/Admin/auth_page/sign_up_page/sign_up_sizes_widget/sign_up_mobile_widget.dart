import 'package:flutter/material.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../login_page/login_widgets/login_button_widget.dart';
import '../../login_page/login_widgets/login_language_button_widget.dart';
import '../../login_page/login_widgets/password_widget.dart';
import '../../login_page/login_widgets/user_name_widget.dart';

class SignUpMobileWidget extends StatelessWidget {
  const SignUpMobileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            color: AppColors.orangeColor,
            height: 30,
            width: double.infinity,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    const LoginLanguageButtonWidget(),
                    Image.asset(
                      AppImageKeys.sarLogo,
                      height: 50,
                      width: 170,
                      fit: BoxFit.fill,
                    ),
                    const TextInAppWidget(
                      text: AppLanguageKeys.signUpTitleKey,
                      textSize: 25,
                      fontWeightIndex:
                      FontSelectionData.boldFontFamily,
                    ),
                    const SizedBox(height: 5,),

                    const UserNameWidget(text: AppLanguageKeys.centerNameKey,),
                    const UserNameWidget(text: AppLanguageKeys.phoneNumberKey,),
                    const UserNameWidget(text:AppLanguageKeys.emailKey,),
                    const PasswordWidget(),
                    const PasswordWidget(text: AppLanguageKeys.confirmPasswordKey,),
                    const SizedBox(height: 10,),
                   const  LoginButtonWidget(text:AppLanguageKeys.createAccountKey,),
                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ),
        ],

    );
  }
}
