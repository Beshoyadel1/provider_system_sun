import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_state.dart';

import '../../../../../features/auth_page/presentation/pages/login_page/login_widgets/login_button_widget.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../features/auth_page/presentation/pages/login_page/login_widgets/login_image.dart';
import '../../../../../features/auth_page/presentation/pages/login_page/login_widgets/user_text_field_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;
  final bool returnToAccount;

  const ChangePasswordPage({
    super.key,
    required this.email,
    this.returnToAccount = false,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();

    passwordController = TextEditingController();

    confirmPasswordController = TextEditingController();

    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // =========================================================
  // CHANGE PASSWORD
  // =========================================================

  String? _validatePassword(String? value) {
    return value == null || value.trim().isEmpty
        ? AppLanguageKeys.authPasswordRequired
        : null;
  }

  void _changePassword() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final password = passwordController.text.trim();

    final confirmPassword = confirmPasswordController.text.trim();

    // =======================================================
    // CHECK PASSWORD MATCH
    // =======================================================

    if (password != confirmPassword) {
      AppSnackBar.showError(
        AppLanguageKeys.passwordsDoNotMatch,
      );

      return;
    }

    // =======================================================
    // CALL API
    // =======================================================

    context.read<AuthCubit>().changePassword(
          user: widget.email,
          password: password,
          updateStoredPassword: widget.returnToAccount,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous is ChangePasswordLoading || current is ChangePasswordLoading,
      builder: (context, state) => PopScope(
        canPop: state is! ChangePasswordLoading,
        child: Scaffold(
          backgroundColor:
              widget.returnToAccount ? AppColors.scaffoldColor : null,
          body: Row(
            children: [
              // ===================================================
              // FORM
              // ===================================================

              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: AppBar(
                        backgroundColor: widget.returnToAccount
                            ? AppColors.scaffoldColor
                            : AppColors.orangeColor,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        child: Center(
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 500),
                              child: Form(
                                key: formKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.returnToAccount)
                                      const TextInAppWidget(
                                        text: AppLanguageKeys.changePassword,
                                        textColor: AppColors.darkColor,
                                        textSize: 22,
                                        fontWeightIndex:
                                            FontSelectionData.boldFontFamily,
                                      ),
                                    // =================================
                                    // PASSWORD
                                    // =================================

                                    const TextInAppWidget(
                                      text: AppLanguageKeys.password,
                                      textColor: AppColors.darkColor,
                                      textSize: 20,
                                      fontWeightIndex:
                                          FontSelectionData.semiBoldFontFamily,
                                    ),

                                    UserTextFieldWidget(
                                      type: UserFieldType.password,
                                      controller: passwordController,
                                      validator: _validatePassword,
                                      readOnly: state is ChangePasswordLoading,
                                      showPasswordVisibilityToggle: true,
                                      showValidationMessage: true,
                                    ),

                                    // =================================
                                    // CONFIRM PASSWORD
                                    // =================================

                                    const TextInAppWidget(
                                      text: AppLanguageKeys.confirmPasswordKey,
                                      textColor: AppColors.darkColor,
                                      textSize: 20,
                                      fontWeightIndex:
                                          FontSelectionData.semiBoldFontFamily,
                                    ),

                                    UserTextFieldWidget(
                                      type: UserFieldType.password,
                                      controller: confirmPasswordController,
                                      validator: _validatePassword,
                                      readOnly: state is ChangePasswordLoading,
                                      showPasswordVisibilityToggle: true,
                                      showValidationMessage: true,
                                    ),

                                    // =================================
                                    // BUTTON
                                    // =================================

                                    BlocConsumer<AuthCubit, AuthState>(
                                      listenWhen: (
                                        previous,
                                        current,
                                      ) =>
                                          current is ChangePasswordSuccess ||
                                          current is ChangePasswordError,
                                      listener: (
                                        context,
                                        state,
                                      ) {
                                        // =========================
                                        // SUCCESS
                                        // =========================

                                        if (state is ChangePasswordSuccess) {
                                          AppSnackBar.showSuccess(
                                            state.message,
                                          );
                                          Navigator.pop(context);
                                          if (!widget.returnToAccount) {
                                            Navigator.pop(context);
                                          }
                                        }

                                        // =========================
                                        // ERROR
                                        // =========================

                                        if (state is ChangePasswordError) {
                                          AppSnackBar.showError(
                                            state.message,
                                          );
                                        }
                                      },
                                      builder: (
                                        context,
                                        state,
                                      ) {
                                        final isLoading =
                                            state is ChangePasswordLoading;

                                        return LoginButtonWidget(
                                          text: widget.returnToAccount
                                              ? AppLanguageKeys.save
                                              : AppLanguageKeys.send,
                                          isLoading: isLoading,
                                          onPressed: isLoading
                                              ? null
                                              : _changePassword,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ===================================================
              // IMAGE
              // ===================================================

              if (!widget.returnToAccount &&
                  MediaQuery.of(context).size.width >
                      ValuesOfAllApp.mobileWidth)
                const LoginImage(),
            ],
          ),
        ),
      ),
    );
  }
}
