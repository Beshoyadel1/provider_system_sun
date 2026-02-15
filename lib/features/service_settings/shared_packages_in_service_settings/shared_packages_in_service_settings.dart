import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../features/service_settings/shared_packages_in_service_settings/sub/add_shared_packages_in_service_settings/add_shared_packages_in_service_settings.dart';
import '../../../../../features/service_settings/shared_packages_in_service_settings/screens/list_data_shared_packages_in_service_settings.dart';
import '../../../../../features/service_settings/car_spare_parts_in_service_settings/screens/floating_action_button_screen.dart';
import '../../../../../features/service_settings/custom_widget/appbar_dashboard_widget.dart';
import '../../../../../features/service_settings/custom_widget/backgroundDesktop.dart';
import '../../../../../core/utilies/map_of_all_app.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/language/language_constant.dart';


class SharedPackagesInServiceSettings extends StatelessWidget {
  const SharedPackagesInServiceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    bool isMobile = size.width <= ValuesOfAllApp.mobileWidth;
    bool isTabletCustom = size.width > ValuesOfAllApp.mobileWidth &&
        size.width <= ValuesOfAllApp.customTabWidth;
    bool isTab = size.width > ValuesOfAllApp.tabWidth;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: ListDataSharedPackagesInServiceSettings()
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButtonScreen(
        onPressed: () {
          Navigator.pop(context);
          Navigator.of(context).push(
              NavigateToPageWidget(const AddSharedPackagesInServiceSettings()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}