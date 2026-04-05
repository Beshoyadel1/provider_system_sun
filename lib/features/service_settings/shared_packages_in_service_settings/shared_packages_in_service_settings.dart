import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_cubit.dart';
import 'package:sun_web_system/features/service_settings/shared_packages_in_service_settings/create_package_dialog.dart';
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
    return BlocProvider(
      create: (_) => ProviderPackagesCubit()..getPackages(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: ListDataSharedPackagesInServiceSettings(),
                  ),
                ),
              ],
            ),
          ),
        ),


        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButtonScreen(
              onPressed: () async {

                final result = await showDialog(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProviderPackagesCubit>(),
                    child: const CreatePackageDialog(),
                  ),
                );

                if (result == true) {
                  context.read<ProviderPackagesCubit>().getPackages();
                }
              },
            );
          },
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}