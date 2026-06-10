import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/employee_wrapper_request.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_state.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_widgets/login_button_widget.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_widgets/login_language_button_widget.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';
import 'package:sun_web_system/features/employee/data/model/employee_model/employee_model.dart';

class SignUpMobileEmpWidget extends StatefulWidget {
  const SignUpMobileEmpWidget({super.key});

  @override
  State<SignUpMobileEmpWidget> createState() => _SignUpMobileEmpWidgetState();
}

class _SignUpMobileEmpWidgetState extends State<SignUpMobileEmpWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Align(
            alignment: AlignmentGeometry.topCenter,
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
                        Navigator.pop(context,true);
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
                            : () async {
                          if (!_formKey.currentState!.validate()) return;

                          final password = passwordController.text.trim();
                          final confirm =
                          confirmPasswordController.text.trim();

                          if (password != confirm) {
                            AppSnackBar.showError(
                                AppLanguageKeys.passwordsDoNotMatch);
                            return;
                          }
                          final user = await AuthLocalStorage.getUser();

                          print("userid = ${user?.userid}");
                          print("type = ${user?.type}");
                          print("providerDetails = ${user?.providerDetails}");

                          final request = CreateUserRequest(
                            username: usernameController.text.trim(),
                            phone: phoneController.text.trim(),
                            email: emailController.text.trim(),
                            password: password,
                            type: UserType.employeeUser,
                            employeeDetails: EmployeeWrapperRequest(
                              employeeDetails: EmployeeModel(
                                provid: user?.userid,
                              ),
                            ),
                          );

                          debugPrint(
                            jsonEncode(request.toJson()),
                          );

                          context.read<AuthCubit>().signup(request);
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
    );
  }
}
