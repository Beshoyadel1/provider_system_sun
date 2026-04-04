import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/general/car/car_brand/get_car_brand_models_model/car_brand_data_model.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_state.dart';
import '../../../../custom_widget/select_model_car_text_image_orange_line_widget.dart';

class ListOfChooseBrandCarInSecondContainerFirstScreenCarBrandSettings
    extends StatelessWidget {
  const ListOfChooseBrandCarInSecondContainerFirstScreenCarBrandSettings(
      {super.key});

  int getItemsPerRow(double width) {
    if (width >= 1200) return 8;
    if (width >= 800) return 4;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final itemsPerRow = getItemsPerRow(width);

    return BlocBuilder<SelectCarModelSettingCubit, SelectCarModelSettingState>(
      builder: (context, state) {
        if (state.isLoadingBrands) {
          return const Center(child: CircularProgressIndicator());
        }

        final brands = state.brands;
        final rowCount = (brands.length / itemsPerRow).ceil();

        return Column(
          children: List.generate(rowCount, (rowIndex) {
            final start = rowIndex * itemsPerRow;
            final end = (start + itemsPerRow < brands.length)
                ? start + itemsPerRow
                : brands.length;

            final rowCars = brands.sublist(start, end);

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: rowCars.asMap().entries.map((entry) {
                  final index = entry.key;
                  final car = entry.value;
                  final globalIndex = start + index;

                  final isSelected = state.selectedBrandIndex == globalIndex;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SelectModelCarTextImageOrangeLineWidget(
                        text: car.name ?? '',
                        imageBytes: car.image,
                        isSelected: isSelected,
                        onTap: () => context
                            .read<SelectCarModelSettingCubit>()
                            .selectBrand(globalIndex), // 🔥 مهم
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        );
      },
    );
  }
}
