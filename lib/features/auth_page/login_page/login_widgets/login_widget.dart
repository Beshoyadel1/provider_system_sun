import 'package:flutter/material.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../features/store_page/store_page.dart';
import '../../../../../../core/model/user/login_model/login_repository.dart';
import '../../../../../../core/model/user/login_model/login_request.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import 'login_button_widget.dart';
import 'password_widget.dart';
import 'user_name_widget.dart';



class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.loginKey,
          textSize: 20,
          fontWeightIndex: FontSelectionData.boldFontFamily,
        ),
        const TextInAppWidget(
          text: AppLanguageKeys.enterPhoneAndPasswordKey,
          textSize: 18,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.darkColor,
        ),

        UserNameWidget(controller: userNameController),
        PasswordWidget(controller: passwordController),

        const SizedBox(height: 10),

        const TextInAppWidget(
          text: AppLanguageKeys.forgotPasswordKey,
          textSize: 14,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
          textColor: AppColors.darkColor,
        ),

        LoginButtonWidget(
          text: AppLanguageKeys.loginKey,
          onPressed: () async {
            final String user = userNameController.text.trim();
            final String password = passwordController.text.trim();

            if (user.isEmpty || password.isEmpty) {
              AppSnackBar.showError(AppLanguageKeys.enterUsernameAndPassword);
              return;
            }

            LoginRequest loginRequest = LoginRequest(
              user: user,
              password: password,
            );

            bool isSuccess = await loginFunction(loginRequest: loginRequest);

            if (isSuccess) {
              Navigator.of(context).pushReplacement(
                NavigateToPageWidget(const StorePage()),
              );
            }
          },
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}

