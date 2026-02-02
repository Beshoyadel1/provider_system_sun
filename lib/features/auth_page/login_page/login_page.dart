import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/auth_page/auth_cubit/auth_state.dart';
import '../../../../../features/auth_page/auth_cubit/auth_cubit.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';
import 'login_devices_sizes_widget/login_mobile_widget.dart';
import 'login_devices_sizes_widget/login_web_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;

    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final bool isLoading = state is AuthLoginLoading;

          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.scaffoldColor,
                  ),
                  child: isMobile
                      ? const LoginMobileWidget()
                      : const LoginWebWidget(),
                ),

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
            ),
          );
        },
      ),
    );
  }
}
