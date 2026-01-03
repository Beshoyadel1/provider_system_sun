import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/cubit/cars_model_cubit/car_model_cubit/car_model_cubit.dart';
import '../../../../../../core/cubit/cars_model_cubit/car_model_cubit/car_model_state.dart';
import '../../../../../../core/theming/text_styles.dart';
import '../../../../../../core/pages_widgets/general_widgets/custom_container.dart';
import '../../../../../../core/theming/assets.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/fonts.dart';
import '../../../../../../core/language/language_constant.dart';
import 'car_name_list.dart';
import 'car_name_listview.dart';
import 'car_category.dart';

class ChooseCarModel extends StatelessWidget {
  const ChooseCarModel({super.key});

  @override
  Widget build(BuildContext context) {
    return     Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarCategory(),
              const SizedBox(
                height: 24,
              ),
              BlocBuilder<CarModelCubit, CarModelState>(
                builder: (context, state) {
                  String selectedCar = '';
                  if (state is SelectedCarState) {
                    selectedCar = state.selectedCarName;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      CustomCardCar(
                        heightSizeBox: 88,
                        typeModel: CarNameList,
                        heightContainer: 88,
                        widthContainer: 88,
                        heightImage: 30,
                        widthImage: 34,
                        selectedCarName: selectedCar,
                        scrollDirection: Axis.horizontal,
                      ),
                      CustomCardCar(
                        heightSizeBox: 88,
                        typeModel: CarNameList,
                        heightContainer: 88,
                        widthContainer: 88,
                        heightImage: 30,
                        widthImage: 34,
                        selectedCarName: selectedCar,
                        scrollDirection: Axis.horizontal,
                      ),
                    ],
                  );
                },
              ),

            ]);
  }
}
