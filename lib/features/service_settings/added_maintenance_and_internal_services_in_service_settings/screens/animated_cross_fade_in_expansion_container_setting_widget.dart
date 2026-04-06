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
    extends StatefulWidget {
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
  State<AnimatedCrossFadeInExpansionContainerSettingWidget>
  createState() =>
      _AnimatedCrossFadeInExpansionContainerSettingWidgetState();
}

class _AnimatedCrossFadeInExpansionContainerSettingWidgetState
    extends State<
        AnimatedCrossFadeInExpansionContainerSettingWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<SelectCarModelSettingCubit>()
          .selectBrand(widget.index);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ImageTextWidget(
            text: widget.text,
            image: widget.image,
          ),

          BlocBuilder<DetailsContainerSettingCubit,
              DetailsContainerSettingState>(
            builder: (context, state) {
              return Column(
                children: [
                  RowRadioListTileSetting(index: widget.index),

                  if (state.selectedOption == 0)
                    DataViewOfUnifiedPriceForAll(
                      index: widget.index,
                    )
                  else
                    if (state.selectedOption == 1)
                      DataViewOfPricePerCategory(
                        brandIndex: widget.index,
                        brandId: widget.brandId,
                      ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
