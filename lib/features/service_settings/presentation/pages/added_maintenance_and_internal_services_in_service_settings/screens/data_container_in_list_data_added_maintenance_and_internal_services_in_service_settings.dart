import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/custom_widget/expansion_container_setting_widget.dart';
import '../../../../../../features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/icon_car_orange_text_of_added_maintenance_and_internal_services.dart';

class DataContainerInListDataAddedMaintenanceAndInternalServicesInServiceSettings
    extends StatelessWidget {
  final String textServiceScreen;
  final Uint8List imageMemory;

  const DataContainerInListDataAddedMaintenanceAndInternalServicesInServiceSettings(
      {super.key, required this.textServiceScreen, required this.imageMemory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  const FirstRowInDataContainerInListDataFirstScreenServiceSetting(),
          IconCarOrangeTextOfAddedMaintenanceAndInternalServices(
            text: textServiceScreen,
            imageMemory: imageMemory,
          ),
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
                        serviceId: service.id!,
                        isDoneTask: true,
                        onTap: () {
                          context.read<CreateProvServiceCubit>().setService(
                                id: service.id!,
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
