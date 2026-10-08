import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/otp_page/otp_page.dart';

class AccountChangePasswordButton extends StatefulWidget {
  const AccountChangePasswordButton({
    super.key,
    required this.user,
    this.enabled = true,
  });

  final CreateUserRequest? user;
  final bool enabled;

  @override
  State<AccountChangePasswordButton> createState() =>
      _AccountChangePasswordButtonState();
}

class _AccountChangePasswordButtonState
    extends State<AccountChangePasswordButton> {
  bool _isChangingPassword = false;
  AuthCubit? _flowCubit;

  @override
  void dispose() {
    final cubit = _flowCubit;
    if (cubit != null && !cubit.isClosed) unawaited(cubit.close());
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_isChangingPassword) return;

    final email = widget.user?.email?.trim() ?? '';
    final phone = widget.user?.phone?.trim() ?? '';
    if (email.isEmpty) {
      AppSnackBar.showError(AppLanguageKeys.userNotFound);
      return;
    }
    if (phone.isEmpty) {
      AppSnackBar.showError(AppLanguageKeys.phoneNumberNotFoundForThisAccount);
      return;
    }

    setState(() => _isChangingPassword = true);
    // This flow must not change the authenticated app's AuthCubit state.
    final cubit = AuthCubit();
    _flowCubit = cubit;
    try {
      final sent = await cubit.sendOtp(
        email: email,
        phone: phone,
        purpose: OtpPurpose.forgotPassword,
        languageCode: Localizations.localeOf(context).languageCode,
      );
      if (!mounted) return;
      if (!sent) {
        AppSnackBar.showError(AppLanguageKeys.failedToSendVerificationCode);
        return;
      }

      await Navigator.push(
        context,
        NavigateToPageWidget(
          BlocProvider.value(
            value: cubit,
            child: OtpPage(
              email: email,
              purpose: OtpPurpose.forgotPassword,
              returnToAccount: true,
            ),
          ),
        ),
      );
    } finally {
      if (!cubit.isClosed) await cubit.close();
      _flowCubit = null;
      if (mounted) setState(() => _isChangingPassword = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.orangeColor),
      onPressed: widget.enabled && widget.user != null && !_isChangingPassword
          ? _changePassword
          : null,
      icon: _isChangingPassword
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.lock_outline,
              color: AppColors.whiteColor, size: 18),
      label: const TextInAppWidget(
        text: AppLanguageKeys.changePassword,
        textColor: AppColors.whiteColor,
        textSize: 13,
      ),
    );
  }
}
