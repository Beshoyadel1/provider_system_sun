import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../core/theming/assets.dart';
import '../../../../custom_widget/select_model_car_text_image_orange_line_widget.dart';
import '../../../logic/select_car_model_setting_cubit.dart';
import '../../../logic/select_car_model_setting_state.dart';

class MobileOfListOfChooseModelCarInSecondContainerFirstScreenCarModelSettings
    extends StatelessWidget {
  const MobileOfListOfChooseModelCarInSecondContainerFirstScreenCarModelSettings(
      {super.key});

  static const int itemsPerRow = 2;

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(rowCount, (rowIndex) {
              final start = rowIndex * itemsPerRow;
              final end = (start + itemsPerRow < carModels.length)
                  ? start + itemsPerRow
                  : carModels.length;

              final rowCars = carModels.sublist(start, end);

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildRow(context, rowCars, state, start),
              );
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
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
  CarModel(name: 'Nissan', imagePath: AppImageKeys.logo10),
  CarModel(name: 'مرسيدس', imagePath: AppImageKeys.logo11),
  CarModel(name: 'BMW', imagePath: AppImageKeys.logo12),
  CarModel(name: 'بورش', imagePath: AppImageKeys.logo13),
  CarModel(name: 'تويوتا', imagePath: AppImageKeys.logo10),
  CarModel(name: 'كيا', imagePath: AppImageKeys.logo11),
  CarModel(name: 'هوندا', imagePath: AppImageKeys.logo12),
  CarModel(name: 'جيب', imagePath: AppImageKeys.logo13),
  CarModel(name: 'فورد', imagePath: AppImageKeys.logo10),
  CarModel(name: 'هيونداي', imagePath: AppImageKeys.logo11),
  CarModel(name: 'سوزوكي', imagePath: AppImageKeys.logo12),
  CarModel(name: 'رنج روفر', imagePath: AppImageKeys.logo13),
  CarModel(name: 'شيفروليه', imagePath: AppImageKeys.logo10),
  CarModel(name: 'بيجو', imagePath: AppImageKeys.logo11),
  CarModel(name: 'سكودا', imagePath: AppImageKeys.logo12),
  CarModel(name: 'اوبل', imagePath: AppImageKeys.logo13),
];
