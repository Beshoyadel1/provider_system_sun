import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/cubit/app_cubit/app_cubit.dart';
import 'package:sun_web_system/core/utilies/map_of_all_app.dart';
import 'package:sun_web_system/features/service_settings/logic/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/cubit/service_settings_cubit/service_settings_state.dart';
import 'package:sun_web_system/features/service_settings/logic/service_settings_helper/service_settings_helper.dart';
import '../../../../../../features/service_settings/shared_packages_in_service_settings/shared_packages_in_service_settings.dart';
import '../../../../../../features/service_settings/car_spare_parts_in_service_settings/car_spare_parts_in_service_settings.dart';
import '../../../../../../features/service_settings/internal_maintenance_and_services_in_service_settings/internal_maintenance_and_services_in_service_settings.dart';
import '../../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/added_maintenance_and_internal_services_in_service_settings.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../features/service_settings/custom_widget/container_in_data_container_in_list_data_first_screen_service_setting_widget.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/first_row_in_data_container_in_list_data_first_screen_service_setting.dart';

class DataContainerInListDataFirstScreenServiceSetting extends StatelessWidget {
  const DataContainerInListDataFirstScreenServiceSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = AppCubit.get(context).isAllAppLanguageArabic;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FirstRowInDataContainerInListDataFirstScreenServiceSetting(
            text1: AppLanguageKeys.nissanServiceSettings,
            text2: AppLanguageKeys.serviceSettingsDetails,
          ),

          const SizedBox(height: 30),

          BlocBuilder<ServiceSettingsCubit, ServiceSettingsState>(
            buildWhen: (previous, current) =>
            current is ServiceSettingsLoading ||
                current is ServiceSettingsSuccess ||
                current is ServiceSettingsError,
            builder: (context, state) {
              if (state is ServiceSettingsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ServiceSettingsError) {
                return Text(state.message);
              }
              if (state is ServiceSettingsSuccess) {
                return Column(
                  children: List.generate(state.services.length, (index) {
                    final service = state.services[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child:
                      ContainerInDataContainerInListDataFirstScreenServiceSettingWidget(
                        imageMemory: service.image,
                        title: ServiceSettingsHelper.getServiceName(
                          service: service,
                          isArabic: isArabic,
                        ),
                          onTap: () {
                            ServiceSettingsHelper.handleNavigation(context, service.id);
                          }
                      ),
                    );
                  }),
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}