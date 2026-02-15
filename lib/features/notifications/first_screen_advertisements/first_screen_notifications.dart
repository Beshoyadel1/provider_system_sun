import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../features/notifications/first_screen_advertisements/screens/list_data_first_screen_notifications.dart';
import '../../../../../../features/service_settings/custom_widget/appbar_dashboard_widget.dart';
import '../../../../../../features/service_settings/custom_widget/backgroundDesktop.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../core/theming/colors.dart';

class FirstScreenNotifications extends StatelessWidget {
  const FirstScreenNotifications({super.key});

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
                    child: ListDataFirstScreenNotifications()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
