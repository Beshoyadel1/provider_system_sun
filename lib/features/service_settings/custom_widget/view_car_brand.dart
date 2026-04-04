import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/animated_cross_fade_in_expansion_container_setting_widget.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';

class ViewCarBrand extends StatelessWidget {
  final String name;
  final Uint8List? image;
  final int index;

  const ViewCarBrand({
    super.key,
    required this.name,
    this.image,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailsContainerSettingCubit(),
      child: GestureDetector(
        onTap: () {
          context.read<SelectCarModelSettingCubit>().selectBrand(index);

          /// optional expand
          context.read<DetailsContainerSettingCubit>().toggle();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  image != null
                      ? Image.memory(image!, width: 30, height: 30)
                      : const Icon(Icons.directions_car),

                  const SizedBox(width: 10),

                  TextInAppWidget(
                    text: name,
                    textSize: 13,
                    fontWeightIndex:
                    FontSelectionData.mediumFontFamily,
                    textColor: AppColors.darkColor,
                  ),
                ],
              ),

              /// 🔥 IMPORTANT
              AnimatedCrossFadeInExpansionContainerSettingWidget(
                index: index,
              ),
            ],
          ),
        ),
      ),
    );
  }
}