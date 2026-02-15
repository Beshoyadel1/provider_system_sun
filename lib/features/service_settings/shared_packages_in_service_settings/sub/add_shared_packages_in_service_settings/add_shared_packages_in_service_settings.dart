import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../../features/service_settings/shared_packages_in_service_settings/sub/add_shared_packages_in_service_settings/screens/list_data_add_shared_packages_in_service_settings.dart';
import '../../../../../../../features/service_settings/custom_widget/appbar_dashboard_widget.dart';
import '../../../../../../../features/service_settings/custom_widget/backgroundDesktop.dart';
import '../../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../../../core/theming/colors.dart';
import '../../../../../../../core/language/language_constant.dart';

class AddSharedPackagesInServiceSettings extends StatelessWidget {
  const AddSharedPackagesInServiceSettings({super.key});

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
        const Expanded(
          flex: 3,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppbarDashboardWidget(
              title: AppLanguageKeys.serviceSettings,
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: ListDataAddSharedPackagesInServiceSettings()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
