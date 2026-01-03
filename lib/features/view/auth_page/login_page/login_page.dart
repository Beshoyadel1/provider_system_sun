import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utilies/map_of_all_app.dart';
import '../../../../core/cubit/auth_cubit/auth_cubit.dart';
import '../../../../core/theming/colors.dart';
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
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.scaffoldColor,
          ),
          child: isMobile ? const LoginMobileWidget() : const LoginWebWidget(),
        ),
      ),
    );
  }
}
