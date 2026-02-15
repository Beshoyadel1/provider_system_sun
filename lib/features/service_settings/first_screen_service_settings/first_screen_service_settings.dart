import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../features/service_settings/first_screen_service_settings/screens/list_data_first_screen_service_setting.dart';
import '../../../../../core/theming/colors.dart';

class FirstScreenServiceSettings extends StatelessWidget {
  const FirstScreenServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;

    return const Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: ListDataFirstScreenServiceSetting()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
