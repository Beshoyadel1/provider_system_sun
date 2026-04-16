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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<int, TextEditingController> controllers = {};
  late TextEditingController taxController;

  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    taxController = TextEditingController();
  }

  void onSubmit() {
    setState(() {
      isSubmitted = true;
    });

    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<CreateProvServiceCubit>();

    cubit.cars.clear();
    cubit.selectedBrandIds.clear();

    controllers.forEach((modelId, controllerPrice) {
      final price = double.tryParse(controllerPrice.text.trim()) ?? 0;

      if (price > 0) {
        cubit.cars.add(
          CarModelCreateProvServiceRequest(
            id: 0,
            carbrandid: widget.brandId,
            carmodelid: modelId,
            price: price,
            cost: 0,
          ),
        );

        cubit.selectedBrandIds.add(widget.brandId);
      }
    });

    final request = CreateProvServiceRequest(
      taxid: int.tryParse(taxController.text) ?? 0,
      brands: [],
      cars: cubit.cars,
    );

    cubit.createProvService(request: request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateProvServiceCubit, CreateProvServiceState>(
      listener: (context, state) {
        if (state is CreateProvServiceSuccess) {
          AppSnackBar.showSuccess(AppLanguageKeys.success);

          for (var c in controllers.values) {
            c.clear();
          }

          taxController.clear();
        }

        if (state is CreateProvServiceError) {
          AppSnackBar.showError(state.error);
        }
      },

      child: BlocBuilder<SelectCarModelSettingCubit,
          SelectCarModelSettingState>(
        builder: (context, state) {
          final cubit = context.read<SelectCarModelSettingCubit>();
          final models = cubit.getModelsForBrand(widget.brandId);

          if (models.isEmpty) {
            return const Text("No Models");
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              autovalidateMode: isSubmitted
                  ? AutovalidateMode.onUnfocus
                  : AutovalidateMode.disabled,
              child: Column(
                children: [

                  /// ✅ TAX FIELD
                  Row(
                    children: [
                      Expanded(
                        child: TextFormFieldWidget(
                          textFormController: taxController,
                          fillColor: AppColors.transparent,
                          borderColor: AppColors.darkColor.withOpacity(0.2),
                          hintText: AppLanguageKeys.taxes,
                          hintTextSize: 12,
                          hintTextColor: AppColors.orangeColor,
                          textSize: 15,
                          isDigit: true,

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppLanguageKeys.addAllRequiredFieldsKey;
                            }

                            if (int.tryParse(value) == null) {
                              return "Enter valid number";
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: models.length,
                    itemBuilder: (context, index) {
                      final model = models[index];
                      final modelId = model.id ?? 0;

                      controllers.putIfAbsent(
                        modelId,
                            () => TextEditingController(),
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CarImageTextInSettingWidget(
                          text: model.name ?? '',
                          modelId: modelId,
                          brandId: widget.brandId,
                          imageMemory: model.image,
                          controller: controllers[modelId]!,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
                    onTap: onSubmit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}