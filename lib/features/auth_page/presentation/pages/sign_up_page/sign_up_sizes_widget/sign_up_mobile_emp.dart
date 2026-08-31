import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_state.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_widgets/login_button_widget.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_widgets/login_language_button_widget.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/otp_page/otp_page.dart';


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
                      onChanged: (value) {
                       // print('PHONE NUMBER => $value');
                      },
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
                      listenWhen: (previous, current) =>
                      current is AuthSignupSuccess ||
                          current is AuthSignupError,
                      listener: (context, state) {
                        if (state is AuthSignupSuccess) {
                          final cubit = context.read<AuthCubit>();

                          final email = cubit.verificationEmail;
                          final phone = cubit.verificationPhone;

                          if (email == null ||
                              email.trim().isEmpty ||
                              phone == null ||
                              phone.trim().isEmpty) {
                            AppSnackBar.showError(
                              AppLanguageKeys.somethingWentWrong,
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            NavigateToPageWidget(
                              BlocProvider.value(
                                value: cubit,
                                child: OtpPage(
                                  email: email,
                                  purpose: OtpPurpose.signup,
                                ),
                              ),
                            ),
                          );

                          return;
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
                              // ==========================================
                              // 1. RUN FORM VALIDATION FIRST
                              // ==========================================

                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              // ==========================================
                              // 2. GET VALUES AFTER BASIC VALIDATION
                              // ==========================================

                              final username = usernameController.text.trim();
                              final phone = phoneController.text.trim();
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final confirmPassword =
                              confirmPasswordController.text.trim();

                              // ==========================================
                              // 3. EXTRA VALIDATION
                              // ==========================================

                              // Email
                              final emailRegex = RegExp(
                                r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );

                              if (!emailRegex.hasMatch(email)) {
                                AppSnackBar.showError(
                                  AppLanguageKeys.pleaseEnterValidEmail,
                                );
                                return;
                              }

                              // Password confirmation
                              if (password != confirmPassword) {
                                AppSnackBar.showError(
                                  AppLanguageKeys.passwordsDoNotMatch,
                                );
                                return;
                              }

                              // ==========================================
                              // 4. ONLY NOW CALL API
                              // ==========================================

                              context.read<AuthCubit>().signup(
                                CreateUserRequest(
                                  username: username,
                                  phone: phone,
                                  email: email,
                                  password: password,
                                  type: UserType.providerUser,
                                  providerDetails:
                                  const ProviderDetailsRequest(),
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
