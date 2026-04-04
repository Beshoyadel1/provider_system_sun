// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
// import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_state.dart';
// import '../../../../custom_widget/select_model_car_text_image_orange_line_widget.dart';
//
// class ListOfChooseModelCarInSecondContainerFirstScreenCarModelSettings
//     extends StatelessWidget {
//   const ListOfChooseModelCarInSecondContainerFirstScreenCarModelSettings(
//       {super.key});
//
//   int getItemsPerRow(double width) {
//     if (width >= 1200) return 8;
//     if (width >= 800) return 4;
//     return 2;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final itemsPerRow = getItemsPerRow(width);
//
//     return BlocBuilder<SelectCarModelSettingCubit, SelectCarModelSettingState>(
//       builder: (context, state) {
//         if (state.isLoadingModels) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//       //  final models = state.models;
//
//         final rowCount = (models.length / itemsPerRow).ceil();
//
//         return Column(
//           children: List.generate(rowCount, (rowIndex) {
//             final start = rowIndex * itemsPerRow;
//             final end = (start + itemsPerRow < models.length)
//                 ? start + itemsPerRow
//                 : models.length;
//
//             final rowCars = models.sublist(start, end);
//
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Row(
//                 children: rowCars.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final car = entry.value;
//                   final globalIndex = start + index;
//
//                   final isSelected = state.selectedModelIndex == globalIndex;
//
//                   return Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5),
//                       child: SelectModelCarTextImageOrangeLineWidget(
//                         text: car.name ?? '',
//                         imageBytes: car.image,
//                         isSelected: isSelected,
//                         // onTap: () => context
//                         //     .read<SelectCarModelSettingCubit>()
//                         //     .selectModel(globalIndex),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
// }
