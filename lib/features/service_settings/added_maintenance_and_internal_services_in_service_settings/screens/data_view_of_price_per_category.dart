import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/brand_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/car_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/create_prov_service_request.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import 'package:sun_web_system/features/service_settings/custom_widget/car_image_text_in_setting_widget.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_state.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/car_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/create_prov_service_request.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/pages_widgets/text_form_field_widget.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import 'package:sun_web_system/features/service_settings/custom_widget/car_image_text_in_setting_widget.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_state.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/brand_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/car_model_create_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/create_prov_service_request.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import 'package:sun_web_system/features/service_settings/custom_widget/car_image_text_in_setting_widget.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_state.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_state.dart';

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
    final cubit = context.watch<CreateProvServiceCubit>(); // 👈 مهم watch

    final selected = cubit.brandSelection[widget.brandId];

    final models = context
        .read<SelectCarModelSettingCubit>()
        .getModelsForBrand(widget.brandId);

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
          final existing = cubit.cars.firstWhere(
                (e) =>
            e.carbrandid == widget.brandId &&
                e.carmodelid == modelId,
            orElse: () => CarModelCreateProvServiceRequest(),
          );

          return TextEditingController(
            text: existing.price?.toString() ?? '',
          );
        });

        costControllers.putIfAbsent(modelId, () {
          final existing = cubit.cars.firstWhere(
                (e) =>
            e.carbrandid == widget.brandId &&
                e.carmodelid == modelId,
            orElse: () => CarModelCreateProvServiceRequest(),
          );

          return TextEditingController(
            text: existing.cost?.toString() ?? '',
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