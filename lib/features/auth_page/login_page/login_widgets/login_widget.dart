import 'package:flutter/material.dart';
import '../../../../core/api_functions/user/login_model/login_request.dart';
import '../../../../core/api/dio_function/user_type.dart';
import '../../../../features/auth_page/auth_cubit/auth_cubit.dart';
import '../../../../features/auth_page/auth_cubit/auth_state.dart';
import '../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../features/store_page/store_page.dart';
import '../../../../core/language/language_constant.dart';
import '../../../../core/theming/fonts.dart';
import '../../../../core/theming/text_styles.dart';
import 'login_button_widget.dart';
import 'password_widget.dart';
import 'user_name_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWidget extends StatelessWidget {
   LoginWidget({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextInAppWidget(
            text: AppLanguageKeys.loginKey,
            textSize: 20,
            fontWeightIndex: FontSelectionData.boldFontFamily,
          ),

          UserNameWidget(
            controller: userNameController,
            isEmail: true,
            text: AppLanguageKeys.email,
          ),

          PasswordWidget(controller: passwordController),

      BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) =>
        current is AuthLoginLoading ||
            current is AuthLoginSuccess ||
            current is AuthLoginError ||
            previous is AuthLoginLoading,

        builder: (context, state) {
          final bool isLoading = state is AuthLoginLoading;

          if (state is AuthLoginSuccess) {
            Future.microtask(() {
              Navigator.of(context).pushReplacement(
                NavigateToPageWidget(const StorePage()),
              );
            });
          }

          if (state is AuthLoginError) {
            Future.microtask(() {
              AppSnackBar.showError(state.message);
            });
          }

          return LoginButtonWidget(
            text: AppLanguageKeys.login,
            isLoading: isLoading,
            onPressed: isLoading
                ? null
                : () {
              if (!_formKey.currentState!.validate()) return;

              final loginRequest = LoginRequest(
                user: userNameController.text.trim(),
                password: passwordController.text.trim(),
                type: UserType.providerUser,
              );

              context.read<AuthCubit>().login(loginRequest);
            },
          );
        },
      ),
        ],
      ),
    );
  }
}

