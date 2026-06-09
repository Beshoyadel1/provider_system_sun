import 'package:flutter/material.dart';
import 'package:sun_web_system/features/auth_page/data/request/login_request/login_request.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_state.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/auth_gate.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/check_email_exist/check_email_exist_page.dart';
import '../../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/text_styles.dart';
import 'login_button_widget.dart';
import 'user_text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController userNameController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextInAppWidget(
            text: AppLanguageKeys.loginKey,
            textSize: 20,
            fontWeightIndex: FontSelectionData.boldFontFamily,
          ),

          UserTextFieldWidget(
            controller: userNameController,
            type: UserFieldType.email,
            text: AppLanguageKeys.email,
          ),

          UserTextFieldWidget(
            controller: passwordController,
            type: UserFieldType.password,
            text: AppLanguageKeys.password,
          ),

          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoginSuccess) {
                AppSnackBar.showSuccess(
                  AppLanguageKeys.success,
                );

              }

              if (state is AuthLoginError) {
                AppSnackBar.showError(
                  state.message,
                );
              }
            },
            child: BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) =>
              current is AuthLoginLoading ||
                  current is AuthLoginSuccess ||
                  current is AuthLoginError,
              builder: (context, state) {
                final isLoading = state is AuthLoginLoading;

                return LoginButtonWidget(
                  text: AppLanguageKeys.login,
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () {
                    final email = userNameController.text.trim();
                    final password = passwordController.text.trim();
                    if (email.isEmpty||password.isEmpty) {
                      AppSnackBar.showError(
                        AppLanguageKeys.enterYourData,
                      );
                      return;
                    }

                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );

                    if (!emailRegex.hasMatch(email)) {
                      AppSnackBar.showError(
                        AppLanguageKeys.pleaseEnterValidEmail,
                      );
                      return;
                    }

                    if (!_formKey.currentState!.validate()) return;

                    context.read<AuthCubit>().login(
                      LoginRequest(
                        user: email,
                        password: passwordController.text.trim(),
                        type: UserType.providerUser,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          InkWell(
            onTap: () {
              context.read<AuthCubit>().showRestPassword();
              Navigator.push(
                context,
                NavigateToPageWidget(
                  const CheckEmailExistPage(),
                ),
              );
            },
            child: const TextInAppWidget(
              text: AppLanguageKeys.forgotPasswordKey,
              textSize: 14,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.darkColor,
            ),
          ),
        ],
      ),
    );
  }
}