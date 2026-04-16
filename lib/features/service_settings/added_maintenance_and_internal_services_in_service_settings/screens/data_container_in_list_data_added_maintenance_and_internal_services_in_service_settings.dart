import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/cubit/app_cubit/app_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/cubit/service_settings_cubit/service_settings_state.dart';
import 'package:sun_web_system/features/service_settings/logic/service_settings_helper/service_settings_helper.dart';
import '../../../../../../features/service_settings/custom_widget/expansion_container_setting_widget.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/icon_car_orange_text_of_added_maintenance_and_internal_services.dart';
import '../../../../../../features/service_settings/first_screen_service_settings/screens/first_row_in_data_container_in_list_data_first_screen_service_setting.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/assets.dart';

class DataContainerInListDataAddedMaintenanceAndInternalServicesInServiceSettings
    extends StatelessWidget {
  const DataContainerInListDataAddedMaintenanceAndInternalServicesInServiceSettings(
      {super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = AppCubit.get(context).isAllAppLanguageArabic;

    return  Padding(
      padding:  const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FirstRowInDataContainerInListDataFirstScreenServiceSetting(),
          const IconCarOrangeTextOfAddedMaintenanceAndInternalServices(),
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
                      child: ExpansionContainerSettingWidget(
                        imageMemory: service.image,
                        text: service.getName(context),
                        isDoneTask: true,
                        onTap: (){
                          context.read<CreateProvServiceCubit>().setService(
                            id: service.id!,
                            nameValue: service.name ?? "",
                            latinValue: service.latinName ?? "",
                          );
                          },
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
