import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/features/service_settings/custom_widget/car_image_text_in_setting_widget.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_state.dart';


class DataViewOfPricePerCategory extends StatelessWidget {
  final int brandIndex;
  final int? brandId;

  const DataViewOfPricePerCategory({
    super.key,
    required this.brandIndex,
    required this.brandId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectCarModelSettingCubit,
        SelectCarModelSettingState>(
      builder: (context, state) {
        final cubit = context.read<SelectCarModelSettingCubit>();

        final models = cubit.getModelsForBrand(brandId);

        if (state.isLoadingModels &&
            state.selectedBrandIndex == brandIndex) {
          return const Center(child: CircularProgressIndicator());
        }

        if (models.isEmpty) {
          return const Text("No Models");
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (models.length / 2).ceil(),
            itemBuilder: (context, index) {
              final firstIndex = index * 2;
              final secondIndex = firstIndex + 1;

              final firstModel = models[firstIndex];
              final secondModel = secondIndex < models.length
                  ? models[secondIndex]
                  : null;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CarImageTextInSettingWidget(
                        text: firstModel.name ?? '',
                        brandIndex: brandIndex,
                        modelId: firstModel.id ?? 0,
                        imageMemory: firstModel.image,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: secondModel != null
                          ? CarImageTextInSettingWidget(
                        text: secondModel.name ?? '',
                        brandIndex: brandIndex,
                        modelId: secondModel.id ?? 0,
                        imageMemory: secondModel.image,
                      )
                          : const SizedBox(),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}