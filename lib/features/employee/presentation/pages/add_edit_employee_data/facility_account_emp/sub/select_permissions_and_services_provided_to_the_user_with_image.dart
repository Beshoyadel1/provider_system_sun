import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/employee/presentation/bloc/service_permission_cubit/service_permission_cubit.dart';
import 'package:sun_web_system/features/employee/presentation/custom_widget/check_box_with_text_widget.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_state.dart';

class SelectPermissionsAndServicesProvidedToTheUserWithImage
    extends StatelessWidget {
  final bool isEditMode;

  const SelectPermissionsAndServicesProvidedToTheUserWithImage({
    super.key,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceSettingsCubit, ServiceSettingsState>(
      builder: (context, state) {
        if (state is ServiceSettingsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ServiceSettingsError) {
          return Text(state.message);
        }

        if (state is! ServiceSettingsSuccess) {
          return const SizedBox.shrink();
        }

        // كل الـ services الموجودة في النظام
        final allServices = state.services
            .where(
              (service) => (service.parentId ?? 0) != 0,
        )
            .toList();

        return BlocBuilder<ServicePermissionCubit, List<int>>(
          builder: (context, selectedServiceIds) {
            // =====================================================
            // VIEW MODE
            // =====================================================

            if (!isEditMode) {
              // فقط خدمات الموظف
              final employeeServices = allServices.where(
                    (service) {
                  return selectedServiceIds.contains(
                    service.id,
                  );
                },
              ).toList();

              // الموظف ليس لديه أي service
              if (employeeServices.isEmpty) {
                return const TextInAppWidget(
                  text: AppLanguageKeys.noServicesAssigned,
                  textSize: 14,
                  textColor: AppColors.greyColor,
                );
              }

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: employeeServices.map(
                      (service) {
                    return CheckBoxWithText(
                      serviceId: service.id ?? 0,
                      text: service.getName(context),
                      imageBytes: service.image,
                      readOnly: true,
                    );
                  },
                ).toList(),
              );
            }

            // =====================================================
            // CREATE / EDIT MODE
            // =====================================================

            if (allServices.isEmpty) {
              return const TextInAppWidget(
                text: AppLanguageKeys.noServicesAssigned,
                textSize: 14,
                textColor: AppColors.greyColor,
              );
            }

            // في Edit/Create اعرض كل الخدمات
            // والـ CheckBox نفسه يحدد الموجود في selectedServiceIds

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: allServices.map(
                    (service) {
                  return CheckBoxWithText(
                    serviceId: service.id ?? 0,
                    text: service.getName(context),
                    imageBytes: service.image,
                    readOnly: false,
                  );
                },
              ).toList(),
            );
          },
        );
      },
    );
  }
}