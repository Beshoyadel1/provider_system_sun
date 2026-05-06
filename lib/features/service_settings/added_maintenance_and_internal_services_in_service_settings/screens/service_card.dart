import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import '../../../../../core/api_functions/provider_management/get_prov_services_model/get_prov_services_response.dart';
import '../../../../../core/api_functions/provider_management/update_prov_service_model/update_prov_service_request.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../features/internal_services/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
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

class ServiceCard extends StatefulWidget {
  final GetProvServicesResponse service;

  const ServiceCard({super.key, required this.service});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController latinController;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.service.provService.name);

    latinController =
        TextEditingController(text: widget.service.provService.latinname);
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service.provService;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CreateProvServiceCubit()
            ..initFromApi(_mapToCreateFormat(widget.service)),
        ),
        BlocProvider(
          create: (_) => SelectCarModelSettingCubit()..fetchBrands(),
        ),
        BlocProvider(
          create: (_) => GetTaxCubit()..getTaxAndSelect(service.taxid),
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
                                children: [
                                  EnterNameLatenNameService(
                                    nameController: nameController,
                                    latinNameController: latinController,
                                  ),
                                  const SizedBox(height: 10),
                                  const SelectTaxPage(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<SelectCarModelSettingCubit,
                                SelectCarModelSettingState>(
                              builder: (context, state) {
                                if (state.isLoadingBrands) {
                                  return const CircularProgressIndicator();
                                }

                                return Column(
                                  children: List.generate(state.brands.length,
                                      (index) {
                                    final brand = state.brands[index];

                                    return BlocProvider(
                                      key: ValueKey(brand.id),
                                      create: (_) =>
                                          DetailsContainerSettingCubit(),
                                      child:
                                          AnimatedCrossFadeInExpansionContainerSettingWidget(
                                        index: index,
                                        image: brand.image,
                                        text: brand.getName(context),
                                        brandId: brand.id ?? 0,
                                      ),
                                    );
                                  }),
                                );
                              },
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
                                        brands: cubit.buildBrands(),
                                        cars: cubit.cars,
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
                                        builder: (_) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          title: const TextInAppWidget(
                                            text: AppLanguageKeys.delete,
                                            textSize: 18,
                                            textColor: AppColors.redColor,
                                          ),
                                          content: const TextInAppWidget(
                                            text: AppLanguageKeys.confirmDelete,
                                            textSize: 14,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context,false),
                                              child: const TextInAppWidget(
                                                text: AppLanguageKeys.cancel,
                                                textSize: 14,
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.redColor,
                                              ),
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const TextInAppWidget(
                                                textSize: 14,
                                                text: AppLanguageKeys.delete,
                                                textColor: AppColors.whiteColor,
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
