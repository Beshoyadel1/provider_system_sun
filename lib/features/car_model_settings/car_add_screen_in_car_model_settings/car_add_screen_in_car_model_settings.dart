import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../service_settings_car_model/service_settings_car_model.dart';
import 'screens/list_data_car_add_screen_in_car_model_settings.dart';
import '../first_screen_car_model_settings/screens/last_two_button_in_first_screen_car_model_settings.dart';
import '../../../../../features/service_settings/custom_widget/appbar_dashboard_widget.dart';
import '../../../../../features/service_settings/custom_widget/backgroundDesktop.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/language/language_constant.dart';

class CarAddScreenInCarModelSettings extends StatelessWidget {
  const CarAddScreenInCarModelSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;

    return Row(
      children: [
        if (!isMobile) const backgroundDesktop(),
        Expanded(
          flex: 3,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppbarDashboardWidget(
              title: AppLanguageKeys.carModel,
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: ListDataCarAddScreenInCarModelSettings()),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: LastTwoButtonInFirstScreenCarModelSettings(
              isSave: true,
              onTapAdd: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  NavigateToPageWidget(ServiceSettingsCarModel()),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
