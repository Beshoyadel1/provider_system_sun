import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../features/dashboard/admin/service_settings/custom_widget/backgroundDesktop.dart';
import 'screens/list_data_first_screen_advertisements.dart';
import '../../../../../features/dashboard/Admin/service_settings/custom_widget/appbar_dashboard_widget.dart';
import '../../../../../core/theming/colors.dart';


class FirstScreenAdvertisements extends StatelessWidget {
  const FirstScreenAdvertisements({super.key});

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
                    child: ListDataFirstScreenAdvertisements()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
