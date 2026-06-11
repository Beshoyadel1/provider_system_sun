import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/Details_container_setting_cubit/Details_container_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/Details_container_setting_cubit/Details_container_setting_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/custom_widget/ImageTextWidget.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/data_view_of_price_per_category.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/data_view_of_unified_price_for_all.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/row_radio_list_tile_setting.dart';


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
        final detailsCubit = context.read<DetailsContainerSettingCubit>();

        final selected = context
            .watch<CreateProvServiceCubit>()
            .brandSelection[brandId];

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
                  detailsCubit.toggle();

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
                  child: Form(
                    key: context
                        .read<CreateProvServiceCubit>()
                        .formKeys
                        .putIfAbsent(
                        brandId, () => GlobalKey<FormState>()),

                    autovalidateMode: AutovalidateMode.disabled,

                    child: Column(
                      children: [

                        RowRadioListTileSetting(brandId: brandId),

                        if (selected == 0)
                          DataViewOfUnifiedPriceForAll(
                            brandId: brandId,
                          )
                        else if (selected == 1)
                          DataViewOfPricePerCategory(
                            brandId: brandId,
                            brandIndex: index,
                          )
                        else
                          const SizedBox(),

                      ],
                    ),
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