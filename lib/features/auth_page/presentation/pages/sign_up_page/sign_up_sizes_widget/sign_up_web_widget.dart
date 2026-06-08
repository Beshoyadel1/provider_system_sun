import 'package:flutter/material.dart';
import 'package:sun_web_system/core/utilies/map_of_all_app.dart';
import 'package:sun_web_system/features/auth_page/presentation/pages/sign_up_page/sign_up_sizes_widget/sign_up_mobile_emp.dart';
import '../../login_page/login_widgets/login_image.dart';

class SignUpWebWidget extends StatelessWidget {
  const SignUpWebWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Expanded(child: SignUpMobileEmp()),
        if(MediaQuery.of(context).size.width > ValuesOfAllApp.mobileWidth) const LoginImage(),
      ],
    );
  }
}
