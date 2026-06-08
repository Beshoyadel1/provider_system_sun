import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/data/request/create_prov_service_request/create_prov_service_request.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/internal_services/presentation/pages/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/Details_container_setting_cubit/Details_container_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/Details_container_setting_cubit/Details_container_setting_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/prov_services_cubit/prov_services_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/select_car_model_setting_cubit/select_car_model_setting_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/container_open_close_tab_setting.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/enter_name_laten_name_service.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/select_tax_page.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/petrol_in_service_settings/screens/enter_price_cost_petrol_service.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/petrol_in_service_settings/screens/prov_service_petrol_list_view.dart';

class ExpansionContainerSettingPetrolWidget extends StatefulWidget {
  final String? imagePath, text;
  final bool? isDoneTask;
  final Uint8List? imageMemory;
  final void Function()? onTap;
  final String? initialName;
  final String? initialLatinName;
  final int? initialTaxId;
  final int serviceId;

  const ExpansionContainerSettingPetrolWidget({
    super.key,
    this.imagePath,
    this.imageMemory,
    this.text,
    this.isDoneTask = false,
    this.onTap,
    this.initialName,
    this.initialLatinName,
    this.initialTaxId,
    required this.serviceId,
  });

  @override
  State<ExpansionContainerSettingPetrolWidget> createState() =>
      _ExpansionContainerSettingPetrolWidgetState();
}

class _ExpansionContainerSettingPetrolWidgetState
    extends State<ExpansionContainerSettingPetrolWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController,
      latinNameController,
      priceController,
      costController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.initialName ?? '',
    );

    latinNameController = TextEditingController(
      text: widget.initialLatinName ?? '',
    );
    priceController = TextEditingController(
      text: widget.initialLatinName ?? '',
    );
    costController = TextEditingController(
      text: widget.initialLatinName ?? '',
    );

    if (widget.initialTaxId != null) {
      Future.microtask(() {
        context.read<GetTaxCubit>().selectTaxById(widget.initialTaxId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SelectCarModelSettingCubit()..fetchBrands(),
        ),
        BlocProvider(
          create: (_) => DetailsContainerSettingCubit(),
        ),
        BlocProvider(
          create: (_) => GetTaxCubit()..getTax(),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: (widget.imageMemory == null ||
                                widget.imageMemory!.isEmpty)
                            ? Image.asset(widget.imagePath ?? '')
                            : Image.memory(widget.imageMemory!, width: 50),
                      ),
                      const SizedBox(width: 5),
                      TextInAppWidget(
                        text: widget.text ?? '',
                        textSize: 13,
                        fontWeightIndex: FontSelectionData.mediumFontFamily,
                        textColor: AppColors.darkColor,
                      ),
                    ],
                  ),
                ),
                ContainerOpenCloseTabSetting(
                  isDoneTask: widget.isDoneTask,
                  onTap: widget.onTap,
                )
              ],
            ),
            const SizedBox(height: 10),
            BlocBuilder<SelectCarModelSettingCubit, SelectCarModelSettingState>(
              builder: (context, brandState) {
                final brands = brandState.brands;

                if (brandState.isLoadingBrands) {
                  return const CircularProgressIndicator();
                }

                if (brands.isEmpty) {
                  return const Text("No Brands");
                }

                return BlocBuilder<DetailsContainerSettingCubit,
                    DetailsContainerSettingState>(
                  builder: (context, state) {
                    if (!state.isExpanded) return const SizedBox();

                    return Column(
                      spacing: 10,
                      children: [
                        ProvServicePetrolListView(serviceId: widget.serviceId),
                        const Row(
                          children: [
                            TextInAppWidget(
                              text: AppLanguageKeys.createService,
                              textSize: 15,
                              fontWeightIndex: FontSelectionData.boldFontFamily,
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            spacing: 10,
                            children: [
                              EnterNameLatenNameService(
                                  nameController: nameController,
                                  latinNameController: latinNameController),
                              EnterPriceCostPetrolService(
                                  priceController: priceController,
                                  costController: costController),
                              const SelectTaxPage()
                            ],
                          ),
                        ),
                        BlocListener<CreateProvServiceCubit,
                            CreateProvServiceState>(
                          listener: (context, state) {
                            if (state is CreateProvServiceSuccess) {
                              context
                                  .read<ProvServicesCubit>()
                                  .getProvServices(serviceId: widget.serviceId);

                              nameController.clear();
                              latinNameController.clear();
                              costController.clear();
                              priceController.clear();
                              context.read<GetTaxCubit>().clearTax();

                              AppSnackBar.showSuccess(AppLanguageKeys.success);
                            }

                            if (state is CreateProvServiceError) {
                              AppSnackBar.showError(state.error);
                            }
                          },
                          child: Column(
                            children: [
                              ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
                                text: AppLanguageKeys.add,
                                onTap: () {
                                  final cubit =
                                      context.read<CreateProvServiceCubit>();

                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    AppSnackBar.showError(
                                        AppLanguageKeys.enterYourData);
                                    return;
                                  }

                                  final taxCubit = context.read<GetTaxCubit>();

                                  cubit.createProvService(
                                    request: CreateProvServiceRequest(
                                        taxid: taxCubit.selectedTax!.taxId,
                                        name: nameController.text,
                                        latinname: latinNameController.text,
                                        unifiedprice: double.tryParse(
                                            priceController.text),
                                        cost: double.tryParse(
                                            costController.text),
                                        brands: [],
                                        cars: [],
                                        isunifiedprice: true),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}