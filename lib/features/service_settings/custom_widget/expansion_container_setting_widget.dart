import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_state.dart';
import '../../../../../../../core/language/language_constant.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/animated_cross_fade_in_expansion_container_setting_widget.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/container_open_close_tab_setting.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';

class ExpansionContainerSettingWidget extends StatelessWidget {
  final String? imagePath, text;
  final bool? isDoneTask;
  final Uint8List? imageMemory;

  const ExpansionContainerSettingWidget({
    super.key,
    this.imagePath,
    this.imageMemory,
    this.text,
    this.isDoneTask = false,
  });

  @override
  Widget build(BuildContext context) {
     int sectionsCount = 4;

    return BlocProvider(
      create: (_) => DetailsContainerSettingCubit(),
      child: Builder(
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: (imageMemory == null || imageMemory!.isEmpty)
                                ? Image.asset(imagePath ?? '')
                                : Image.memory(imageMemory!),
                          ),
                          TextInAppWidget(
                            text: text ?? '',
                            textSize: 13,
                            fontWeightIndex:
                            FontSelectionData.mediumFontFamily,
                            textColor: AppColors.darkColor,
                          ),
                        ],
                      ),
                    ),
                    ContainerOpenCloseTabSetting(
                      isDoneTask: isDoneTask,
                    )
                  ],
                ),

                BlocBuilder<DetailsContainerSettingCubit,
                    DetailsContainerSettingState>(
                  builder: (context, state) {
                    if (!state.isExpanded) return const SizedBox();

                    return Column(
                      children: List.generate(sectionsCount, (index) {
                        return BlocProvider(
                          key: ValueKey(index),
                          create: (_) =>
                              DetailsContainerSettingCubit(), // child cubit
                          child:
                          AnimatedCrossFadeInExpansionContainerSettingWidget(
                            index: index,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}