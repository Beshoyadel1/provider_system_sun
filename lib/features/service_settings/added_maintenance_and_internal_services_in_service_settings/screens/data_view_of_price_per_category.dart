import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api_functions/provider_management/create_prov_service_model/car_model_create_prov_service_request.dart';
import '../../../../../features/service_settings/custom_widget/car_image_text_in_setting_widget.dart';
import '../../../../../features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';

class DataViewOfPricePerCategory extends StatefulWidget {
  final int brandIndex;
  final int brandId;

  const DataViewOfPricePerCategory({
    super.key,
    required this.brandIndex,
    required this.brandId,
  });

  @override
  State<DataViewOfPricePerCategory> createState() =>
      _DataViewOfPricePerCategoryState();
}

class _DataViewOfPricePerCategoryState
    extends State<DataViewOfPricePerCategory> {

  final Map<int, TextEditingController> priceControllers = {};
  final Map<int, TextEditingController> costControllers = {};

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CreateProvServiceCubit>();

    final selected = cubit.brandSelection[widget.brandId];

    final models = context
        .read<SelectCarModelSettingCubit>().getModelsForBrand(widget.brandId);

    if (selected != 1) {
      for (var c in priceControllers.values) {
        c.clear();
      }
      for (var c in costControllers.values) {
        c.clear();
      }
    }

    return Column(
      spacing: 10,
      children: models.map((model) {
        final modelId = model.id ?? 0;

        priceControllers.putIfAbsent(modelId, () {
          final existingList = cubit.cars.where(
                (e) =>
            e.carbrandid == widget.brandId &&
                e.carmodelid == modelId,
          );

          final existing =
          existingList.isNotEmpty ? existingList.first : null;

          return TextEditingController(
            text: existing?.price?.toString() ?? '',
          );
        });

        costControllers.putIfAbsent(modelId, () {
          final existingList = cubit.cars.where(
                (e) =>
            e.carbrandid == widget.brandId &&
                e.carmodelid == modelId,
          );

          final existing =
          existingList.isNotEmpty ? existingList.first : null;

          return TextEditingController(
            text: existing?.cost?.toString() ?? '',
          );
        });

        return CarImageTextInSettingWidget(
          text: model.name ?? '',
          modelId: modelId,
          brandId: widget.brandId,
          imageMemory: model.image,
          priceController: priceControllers[modelId]!,
          costController: costControllers[modelId]!,
        );
      }).toList(),
    );
  }
}