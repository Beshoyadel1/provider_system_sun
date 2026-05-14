import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/features/accounts_management/presentation/pages/first_screen_accounts_management_admin_sun/screens/container_first_screen_accounts_management_admin_sun.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';


class FirstScreenAccountsManagementAdminSun extends StatelessWidget {
  const FirstScreenAccountsManagementAdminSun({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: ContainerFirstScreenAccountsManagementAdminSun()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
