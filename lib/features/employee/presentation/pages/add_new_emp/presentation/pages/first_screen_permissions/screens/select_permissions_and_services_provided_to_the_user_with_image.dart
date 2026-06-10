import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/custom_widget/check_box_with_text_widget.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/employee/presentation/pages/add_new_emp/presentation/custom_widget/check_box_with_text_widget.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_state.dart';

class SelectPermissionsAndServicesProvidedToTheUserWithImage extends StatelessWidget {
  const SelectPermissionsAndServicesProvidedToTheUserWithImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceSettingsCubit, ServiceSettingsState>(
      builder: (context, state) {
        if (state is ServiceSettingsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ServiceSettingsSuccess) {
          final childServices = state.services
              .where((service) => (service.parentId ?? 0) != 0)
              .toList();


          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: childServices.map((service) {
              return CheckBoxWithText(
                serviceId: service.id ?? 0,
                text: service.getName(context),
                imageBytes: service.image,
              );
            }).toList(),
          );
        }

        if (state is ServiceSettingsError) {
          return Text(state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }
}