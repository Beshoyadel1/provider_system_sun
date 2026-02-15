import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../car_add_screen_in_car_model_settings/car_add_screen_in_car_model_settings.dart';
import 'screens/last_two_button_in_first_screen_car_model_settings.dart';
import 'screens/list_data_first_screen_car_model_settings.dart';
import '../../../../../features/service_settings/custom_widget/appbar_dashboard_widget.dart';
import '../../../../../features/service_settings/custom_widget/backgroundDesktop.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/language/language_constant.dart';

class FirstScreenCarModelSettings extends StatelessWidget {
  const FirstScreenCarModelSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const AppbarDashboardWidget(
        title: AppLanguageKeys.carModel,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: ListDataFirstScreenCarModelSettings()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: LastTwoButtonInFirstScreenCarModelSettings(
        onTapAdd: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            NavigateToPageWidget(const CarAddScreenInCarModelSettings()),
          );
        },
      ),
    );
  }
}
