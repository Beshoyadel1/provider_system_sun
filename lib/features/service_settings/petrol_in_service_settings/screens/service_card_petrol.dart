import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import 'package:sun_web_system/features/service_settings/petrol_in_service_settings/screens/enter_price_cost_petrol_service.dart';
import '../../../../../core/api_functions/provider_management/get_prov_services_model/get_prov_services_response.dart';
import '../../../../../core/api_functions/provider_management/update_prov_service_model/update_prov_service_request.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/animated_cross_fade_in_expansion_container_setting_widget.dart';
import '../../../../../features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../features/service_settings/logic/prov_services_cubit/prov_services_cubit.dart';
import '../../../../../features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import '../../../../../features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_state.dart';
import '../../../../../features/service_settings/logic/get_tax_cubit/get_tax_cubit.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/enter_name_laten_name_service.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/select_tax_page.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';

class ServiceCardPetrol extends StatefulWidget {
  final GetProvServicesResponse service;

  const ServiceCardPetrol({super.key, required this.service});

  @override
  State<ServiceCardPetrol> createState() => _ServiceCardPetrolState();
}

class _ServiceCardPetrolState extends State<ServiceCardPetrol> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController, latinController,priceController,costController;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.service.provService.name);
    priceController =
        TextEditingController(text: widget.service.provService.uniformprice.toString());
    costController =
        TextEditingController(text: widget.service.provService.cost.toString());
    latinController =
        TextEditingController(text: widget.service.provService.latinname);
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service.provService;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          CreateProvServiceCubit()
            ..initFromApi(_mapToCreateFormat(widget.service)),
        ),
        BlocProvider(
          create: (_) =>
          SelectCarModelSettingCubit()
            ..fetchBrands(),
        ),
        BlocProvider(
          create: (_) =>
          GetTaxCubit()
            ..getTaxAndSelect(service.taxid),
        ),
      ],
      child: Builder(
        builder: (context) {
          final cubit = context.read<CreateProvServiceCubit>();

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              spacing: 10,
              children: [
                const Row(
                  children: [
                    TextInAppWidget(
                      text: AppLanguageKeys.oldService,
                      textSize: 15,
                      fontWeightIndex: FontSelectionData.boldFontFamily,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextInAppWidget(
                            text:
                            "${latinController.text} - ${nameController.text}",
                            textSize: 15,
                            fontWeightIndex: FontSelectionData.boldFontFamily,
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          spacing: 10,
                          children: [
                            EnterNameLatenNameService(
                              nameController: nameController,
                              latinNameController: latinController,
                            ),
                            EnterPriceCostPetrolService(
                                priceController: priceController,
                                costController: costController
                            ),
                            const SelectTaxPage(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child:
                            ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
                              text: AppLanguageKeys.save,
                              onTap: () {
                                final taxCubit =
                                context.read<GetTaxCubit>();

                                if (!(_formKey.currentState?.validate() ??
                                    false)) {
                                  AppSnackBar.showError(
                                      AppLanguageKeys.enterYourData);
                                  return;
                                }

                                final request = UpdateProvServiceRequest(
                                  id: service.id,
                                  serviceId: service.serviceid,
                                  provId: service.provid,
                                  taxId: taxCubit.selectedTax!.taxId,
                                  name: nameController.text,
                                  latinName: latinController.text,
                                  cost: double.tryParse(costController.text),
                                  uniformprice:double.tryParse(priceController.text),
                                  isuniformprice: true,
                                  brands:[],
                                  cars: [],
                                );

                                context
                                    .read<ProvServicesCubit>()
                                    .updateProvService(request: request);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child:
                            ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
                              text: AppLanguageKeys.delete,
                              backGroundColor: AppColors.redColor,
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) =>
                                      AlertDialog(
                                        title: const TextInAppWidget(
                                          text: AppLanguageKeys.delete,
                                          textSize: 20,
                                        ),
                                        content: const TextInAppWidget(
                                          text: AppLanguageKeys.areYouSure,
                                          textSize: 20,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const TextInAppWidget(
                                              text: AppLanguageKeys.cancel,
                                              textSize: 20,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const TextInAppWidget(
                                              text: AppLanguageKeys.delete,
                                              textSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  context
                                      .read<ProvServicesCubit>()
                                      .deleteProvService(
                                    provServiceId: service.id,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                      : const SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _mapToCreateFormat(GetProvServicesResponse service) {
    return {
      "serviceid": service.provService.serviceid,
      "brands": service.brands.map((b) {
        return {
          "id": b.provServiceBrand.id,
          "brandId": b.provServiceBrand.brandid,
          "uniformprice": b.provServiceBrand.uniformprice,
          "cost": b.provServiceBrand.cost,
          "isuniformprice": b.provServiceBrand.isuniformprice,
        };
      }).toList(),
      "cars": service.brands.expand((b) => b.models).map((m) {
        return {
          "id": m.id ?? 0,
          "carbrandid": m.carbrandid,
          "carmodelid": m.carmodelid,
          "price": m.price,
          "cost": m.cost,
        };
      }).toList(),
    };
  }
}
