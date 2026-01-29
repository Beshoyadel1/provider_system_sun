import 'package:flutter/material.dart';
import '../../../../../../core/model/user/create_user_model/create_user_repository.dart';
import '../../../../../../core/model/user/create_user_model/create_user_request.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../features/auth_page/login_page/login_page.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../login_page/login_widgets/login_button_widget.dart';
import '../../login_page/login_widgets/login_language_button_widget.dart';
import '../../login_page/login_widgets/password_widget.dart';
import '../../login_page/login_widgets/user_name_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../../core/model/user/create_user_model/create_user_repository.dart';
import '../../../../../../core/model/user/create_user_model/create_user_request.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../features/auth_page/login_page/login_page.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../login_page/login_widgets/login_button_widget.dart';
import '../../login_page/login_widgets/login_language_button_widget.dart';
import '../../login_page/login_widgets/password_widget.dart';
import '../../login_page/login_widgets/user_name_widget.dart';

class SignUpMobileWidget extends StatefulWidget {
  const SignUpMobileWidget({super.key});

  @override
  State<SignUpMobileWidget> createState() => _SignUpMobileWidgetState();
}

class _SignUpMobileWidgetState extends State<SignUpMobileWidget> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🟢 Main UI
        Column(
          children: [
            SizedBox(
              height: 40,
              child: AppBar(
                backgroundColor: AppColors.orangeColor,
              ),
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
                        fontWeightIndex: FontSelectionData.boldFontFamily,
                      ),

                      UserNameWidget(
                        controller: usernameController,
                        text: AppLanguageKeys.userName,
                      ),
                      UserNameWidget(
                        controller: phoneController,
                        text: AppLanguageKeys.phoneNumberKey,
                      ),
                      UserNameWidget(
                        controller: emailController,
                        text: AppLanguageKeys.emailKey,
                      ),
                      PasswordWidget(controller: passwordController),
                      PasswordWidget(
                        controller: confirmPasswordController,
                        text: AppLanguageKeys.confirmPasswordKey,
                      ),

                      const SizedBox(height: 10),

                      LoginButtonWidget(
                        text: AppLanguageKeys.createAccountKey,
                        onPressed: isLoading ? null : () async {
                          final username =
                          usernameController.text.trim();
                          final phone = phoneController.text.trim();
                          final email = emailController.text.trim();
                          final password =
                          passwordController.text.trim();
                          final confirmPassword =
                          confirmPasswordController.text.trim();

                          if (username.isEmpty ||
                              phone.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty ||
                              confirmPassword.isEmpty) {
                            AppSnackBar.showError(
                                AppLanguageKeys.fillAllFields);
                            return;
                          }

                          if (password != confirmPassword) {
                            AppSnackBar.showError(
                                AppLanguageKeys.passwordsDoNotMatch);
                            return;
                          }

                          setState(() => isLoading = true);

                          CreateUserRequest request = CreateUserRequest(
                            username: username,
                            phone: phone,
                            email: email,
                            password: password,
                          );

                          bool isSuccess = await createUserFunction(
                            createUserRequest: request,
                          );

                          setState(() => isLoading = false);

                          if (isSuccess) {
                            Navigator.of(context).pushReplacement(
                              NavigateToPageWidget(const LoginPage()),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // 🔵 Full screen Cupertino loader overlay
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: AppColors.blackColor.withOpacity(0.25),
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

