import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/api_functions/provider_management/create_prov_service_model/brand_model_create_prov_service_request.dart';
import '../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../features/internal_services/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import '../../../../../../features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../../features/service_settings/logic/create_prov_service_cubit/create_prov_service_state.dart';
import '../../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../../core/language/language_constant.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../core/api_functions/provider_management/create_prov_service_model/create_prov_service_request.dart';

class DataViewOfUnifiedPriceForAll extends StatefulWidget {
  final int index;

  const DataViewOfUnifiedPriceForAll({
    super.key,
    required this.index,
  });

  @override
  State<DataViewOfUnifiedPriceForAll> createState() =>
      _DataViewOfUnifiedPriceForAllState();
}

class _DataViewOfUnifiedPriceForAllState
    extends State<DataViewOfUnifiedPriceForAll> {
  late TextEditingController priceController,costController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController();
    costController = TextEditingController();
  }

  void onSubmit() {
    setState(() {
      isSubmitted = true;
    });

    if (!_formKey.currentState!.validate()) return;

    final request = CreateProvServiceRequest(
      taxid:0,
      brands: [
        BrandModelCreateProvServiceRequest(
          uniformprice: double.tryParse(priceController.text) ?? 0,
          isuniformprice: true,
          cost: double.tryParse(costController.text) ?? 0,
        ),
      ],
      cars: [],
    );

    context.read<CreateProvServiceCubit>().createProvService(
      request: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateProvServiceCubit, CreateProvServiceState>(
      listener: (context, state) {
        if (state is CreateProvServiceLoading) {
        }

        if (state is CreateProvServiceSuccess) {
          AppSnackBar.showSuccess(AppLanguageKeys.success);
          priceController.clear();
          costController.clear();
        }

        if (state is CreateProvServiceError) {
          AppSnackBar.showError(state.error);
        }
      },

      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          autovalidateMode: isSubmitted
              ? AutovalidateMode.onUnfocus
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      textFormController: priceController,
                      fillColor: AppColors.transparent,
                      borderColor: AppColors.darkColor.withOpacity(0.2),
                      hintText: AppLanguageKeys.price,
                      hintTextSize: 12,
                      hintTextColor: AppColors.orangeColor,
                      textSize: 15,
                      textFormWidth: 400,
                      isDigit: true,

                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLanguageKeys.addAllRequiredFieldsKey;
                        }

                        if (double.tryParse(value) == null) {
                          return "Enter valid number";
                        }

                        return null;
                      },

                      onChanged: (_) {
                        if (isSubmitted) {
                          _formKey.currentState!.validate();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldWidget(
                      textFormController: costController,
                      fillColor: AppColors.transparent,
                      borderColor: AppColors.darkColor.withOpacity(0.2),
                      hintText: AppLanguageKeys.cost,
                      hintTextSize: 12,
                      hintTextColor: AppColors.orangeColor,
                      textSize: 15,
                      textFormWidth: 400,
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

                      onChanged: (_) {
                        if (isSubmitted) {
                          _formKey.currentState!.validate();
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
                onTap: onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}