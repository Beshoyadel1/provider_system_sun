import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../custom_widget/select_model_car_text_image_orange_line_widget.dart';
import '../../../logic/select_car_model_setting_cubit.dart';
import '../../../logic/select_car_model_setting_state.dart';

class TabOfListOfChooseCategoryCarInSecondContainerFirstScreenCarModelSettings
    extends StatelessWidget {
  const TabOfListOfChooseCategoryCarInSecondContainerFirstScreenCarModelSettings(
      {super.key});

  static const int itemsPerRow = 4;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SelectCarModelSettingCubit(),
      child:
          BlocBuilder<SelectCarModelSettingCubit, SelectCarModelSettingState>(
        buildWhen: (p, c) => p.selectedIndex != c.selectedIndex,
        builder: (context, state) {
          final rowCount = (carModels.length / itemsPerRow).ceil();

          return Column(
            spacing: 30,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(rowCount, (rowIndex) {
              final start = rowIndex * itemsPerRow;
              final end = (start + itemsPerRow < carModels.length)
                  ? start + itemsPerRow
                  : carModels.length;

              final rowCars = carModels.sublist(start, end);

              return _buildRow(context, rowCars, state, start);
            }),
          );
        },
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    List<CarModel> cars,
    SelectCarModelSettingState state,
    int startIndexOffset,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: cars.asMap().entries.map((entry) {
        final index = entry.key;
        final car = entry.value;
        final globalIndex = startIndexOffset + index;
        final isSelected = state.selectedIndex == globalIndex;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SelectModelCarTextImageOrangeLineWidget(
              text: car.name,
              imagePath: car.imagePath,
              isSelected: isSelected,
              onTap: () => context
                  .read<SelectCarModelSettingCubit>()
                  .selectModel(globalIndex),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CarModel {
  final String name;
  final String imagePath;

  CarModel({required this.name, required this.imagePath});
}

final carModels = [
  CarModel(name: 'CR - V', imagePath: AppImageKeys.car500),
  CarModel(name: 'Koenigsegg', imagePath: AppImageKeys.car501),
  CarModel(name: 'Nissan GT - R', imagePath: AppImageKeys.car502),
  CarModel(name: 'Ariya', imagePath: AppImageKeys.car503),
  CarModel(name: 'BMW', imagePath: AppImageKeys.car500),
  CarModel(name: 'Mercedes', imagePath: AppImageKeys.car501),
  CarModel(name: 'Toyota', imagePath: AppImageKeys.car502),
  CarModel(name: 'Hyundai', imagePath: AppImageKeys.car503),
  CarModel(name: 'Ford', imagePath: AppImageKeys.car500),
  CarModel(name: 'Peugeot', imagePath: AppImageKeys.car501),
  CarModel(name: 'Suzuki', imagePath: AppImageKeys.car502),
  CarModel(name: 'Opel', imagePath: AppImageKeys.car503),
];
