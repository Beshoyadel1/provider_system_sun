import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/model/user/create_user_model/provider_details_request.dart';
import '../../../../core/api/dio_function/user_type.dart';
import '../../../../features/auth_page/auth_cubit/auth_cubit.dart';
import '../../../../features/auth_page/auth_cubit/auth_state.dart';
import '../../../../core/model/user/create_user_model/create_user_request.dart';
import '../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../features/auth_page/login_page/login_page.dart';
import '../../../../core/language/language_constant.dart';
import '../../../../core/theming/assets.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/theming/text_styles.dart';
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
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          current is AuthSignupLoading ||
          current is AuthSignupSuccess ||
          current is AuthSignupError ||
          previous is AuthSignupLoading,
      builder: (context, state) {
        if (state is AuthSignupSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              NavigateToPageWidget(const LoginPage()),
            );
          });
        }

        if (state is AuthSignupError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppSnackBar.showError(state.message);
          });
        }
        final bool isLoading = state is AuthSignupLoading;
        return Column(
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
                        isPhoneNumber: true,
                        controller: phoneController,
                        text: AppLanguageKeys.phoneNumberKey,
                      ),
                      UserNameWidget(
                        isEmail: true,
                        controller: emailController,
                        text: AppLanguageKeys.emailKey,
                      ),
                      PasswordWidget(
                        controller: passwordController,
                      ),
                      PasswordWidget(
                        controller: confirmPasswordController,
                        text: AppLanguageKeys.confirmPasswordKey,
                        isConfirmPassword: true,
                      ),
                      const SizedBox(height: 10),
                      LoginButtonWidget(
                        text: AppLanguageKeys.createAccountKey,
                        onPressed: isLoading
                            ? null
                            : () {
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
                                    AppLanguageKeys.fillAllFields,
                                  );
                                  return;
                                }

                                if (password != confirmPassword) {
                                  AppSnackBar.showError(
                                    AppLanguageKeys.passwordsDoNotMatch,
                                  );
                                  return;
                                }
                                context.read<AuthCubit>().signup(
                                      CreateUserRequest(
                                        username: username,
                                        phone: phone,
                                        email: email,
                                        password: password,
                                        type:UserType.providerUser,
                                        providerDetails: const ProviderDetailsRequest(),
                                      ),

                                    );
                              },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}