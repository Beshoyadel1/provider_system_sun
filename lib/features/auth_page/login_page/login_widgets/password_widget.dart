import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/auth_page/auth_cubit/auth_cubit.dart';
import '../../../../../../features/auth_page/auth_cubit/auth_state.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({
    super.key,
    required this.controller,
    this.text,
    this.isConfirmPassword = false,
  });

  final TextEditingController controller;
  final String? text;
  final bool isConfirmPassword;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
      current is AuthPasswordVisibilityChanged,
      builder: (context, state) {
        final authCubit = context.read<AuthCubit>();

        final bool isObscure = isConfirmPassword
            ? authCubit.isConfirmPasswordObscure
            : authCubit.isPasswordObscure;

        return SizedBox(
          width: 500,
          child: TextFormFieldWidget(
            textFormController: controller,
            text: text ?? AppLanguageKeys.passwordKey,
            isColumn: true,
            obscureText: isObscure,
            textColor: AppColors.darkColor,
            fillColor: AppColors.whiteColor,
            textSize: 17,
            fontWeightIndex: FontSelectionData.boldFontFamily,
            borderColor: AppColors.lightGreyColor,
            enabledBorderRadius:
            const BorderRadius.all(Radius.circular(10)),

            suffixIcon: isObscure
                ? Icons.visibility_off
                : Icons.visibility,
            suffixOnPressed: () {
              if (isConfirmPassword) {
                context
                    .read<AuthCubit>()
                    .toggleConfirmPasswordVisibility();
              } else {
                context
                    .read<AuthCubit>()
                    .togglePasswordVisibility();
              }
            },
          ),
        );
      },
    );
  }
}
