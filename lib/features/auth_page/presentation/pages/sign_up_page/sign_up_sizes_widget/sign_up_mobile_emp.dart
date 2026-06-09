import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/auth_page/data/request/login_request/login_request.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_state.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_widgets/login_button_widget.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_widgets/login_language_button_widget.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';


class SignUpMobileEmp extends StatefulWidget {
  const SignUpMobileEmp({super.key});

  @override
  State<SignUpMobileEmp> createState() => _SignUpMobileEmpState();
}

class _SignUpMobileEmpState extends State<SignUpMobileEmp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: AppBar(backgroundColor: AppColors.orangeColor),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                    UserTextFieldWidget(
                      type: UserFieldType.name,
                      controller: usernameController,
                      text: AppLanguageKeys.userName,
                    ),

                    UserTextFieldWidget(
                      type: UserFieldType.phone,
                      controller: phoneController,
                      text: AppLanguageKeys.phoneNumberKey,
                    ),

                    UserTextFieldWidget(
                      type: UserFieldType.email,
                      controller: emailController,
                      text: AppLanguageKeys.emailKey,
                    ),
                    UserTextFieldWidget(
                      type: UserFieldType.password,
                      controller: passwordController,
                      text: AppLanguageKeys.password,
                    ),
                    UserTextFieldWidget(
                      type: UserFieldType.password,
                      controller: confirmPasswordController,
                      text: AppLanguageKeys.confirmPasswordKey,
                    ),
                    const SizedBox(height: 10),

                    BlocListener<AuthCubit, AuthState>(
                      listener: (context, state) async {
                        if (state is AuthSignupSuccess) {

                          AppSnackBar.showSuccess(
                            AppLanguageKeys.success,
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }

                        if (state is AuthSignupError) {

                          AppSnackBar.showError(
                            state.message,
                          );
                        }
                      },
                      child: BlocBuilder<AuthCubit, AuthState>(
                        buildWhen: (previous, current) =>
                            current is AuthSignupLoading ||
                            current is AuthSignupSuccess ||
                            current is AuthSignupError ||
                            previous is AuthSignupLoading,
                        builder: (context, state) {
                          final isLoading = state is AuthSignupLoading;

                          return LoginButtonWidget(
                            text: AppLanguageKeys.signUpTitleKey,
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () {
                              final username = usernameController.text.trim();
                              final phone = phoneController.text.trim();
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final confirm = confirmPasswordController.text.trim();

                              if (username.isEmpty ||
                                  phone.isEmpty ||
                                  email.isEmpty ||
                                  password.isEmpty ||
                                  confirm.isEmpty) {
                                AppSnackBar.showError(
                                  AppLanguageKeys.enterYourData,
                                );
                                return;
                              }

                              final emailRegex = RegExp(
                                r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );

                              if (!emailRegex.hasMatch(email)) {
                                AppSnackBar.showError(
                                  AppLanguageKeys.pleaseEnterValidEmail,
                                );
                                return;
                              }

                              if (password != confirm) {
                                AppSnackBar.showError(
                                  AppLanguageKeys.passwordsDoNotMatch,
                                );
                                return;
                              }

                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              context.read<AuthCubit>().signup(
                                CreateUserRequest(
                                  username: username,
                                  phone: phone,
                                  email: email,
                                  password: password,
                                  type: UserType.providerUser,
                                  providerDetails: const ProviderDetailsRequest(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
