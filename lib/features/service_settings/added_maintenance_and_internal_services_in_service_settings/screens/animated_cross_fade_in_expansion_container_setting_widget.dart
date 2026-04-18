import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/row_radio_list_tile_setting.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/data_view_of_price_per_category.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/data_view_of_unified_price_for_all.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_state.dart';
import '../../custom_widget/ImageTextWidget.dart';


class AnimatedCrossFadeInExpansionContainerSettingWidget
    extends StatelessWidget {
  final int index;
  final Uint8List? image;
  final String text;
  final int brandId;

  const AnimatedCrossFadeInExpansionContainerSettingWidget({
    super.key,
    required this.index,
    required this.image,
    required this.text,
    required this.brandId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsContainerSettingCubit,
        DetailsContainerSettingState>(
      builder: (context, state) {
        final cubit = context.read<DetailsContainerSettingCubit>();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  cubit.toggle();

                  context
                      .read<SelectCarModelSettingCubit>()
                      .selectBrand(index);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: ImageTextWidget(
                        text: text,
                        image: image,
                      ),
                    ),

                    AnimatedRotation(
                      turns: state.isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ],
                ),
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: state.isExpanded
                    ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      RowRadioListTileSetting(index: index),

                      if (state.selectedOption == 0)
                        DataViewOfUnifiedPriceForAll(
                          index: index,
                        )
                      else if (state.selectedOption == 1)
                        DataViewOfPricePerCategory(
                          brandIndex: index,
                          brandId: brandId,
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                )
                    : const SizedBox(),
              )
            ],
          ),
        );
      },
    );
  }
}
