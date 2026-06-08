import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/cubit/app_cubit/app_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/service_settings_helper/service_settings_helper.dart';
import 'package:sun_web_system/features/service_settings/presentation/custom_widget/container_in_data_container_in_list_data_first_screen_service_setting_widget.dart';

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
                        title: service.getName(context),
                          onTap: () {
                            ServiceSettingsHelper.handleNavigation(context, service.id,service.getName(context),service.image);
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