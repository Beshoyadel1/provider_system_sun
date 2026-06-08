import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/auth_page/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/pages/sign_up_page_emp/sign_up_mobile_emp_widget.dart';

class SignUpPageEmp extends StatelessWidget {
  const SignUpPageEmp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: BlocProvider(
          create: (context) => AuthCubit(),
          child: const SignUpMobileEmpWidget()
      ),
    );
  }
}
