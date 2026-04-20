import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/logic/prov_services_cubit/prov_services_cubit.dart';
import '../../../../../core/api_functions/provider_management/create_prov_service_model/create_prov_service_request.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/prov_service_brands_list_view.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/enter_name_laten_name_service.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/select_tax_page.dart';
import '../../../../../features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import '../../../../../features/service_settings/logic/create_prov_service_cubit/create_prov_service_state.dart';
import '../../../../../features/service_settings/logic/get_tax_cubit/get_tax_cubit.dart';
import '../../../../../features/internal_services/internal_orders/first_screen_internal_orders/screens/big_container_of_new_orders/Container_view_all_in_first_row_in_data_container_in_list_data_first_screen_internal_orders.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_state.dart';
import '../../../../../features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import '../../../../../features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_state.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/animated_cross_fade_in_expansion_container_setting_widget.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/screens/container_open_close_tab_setting.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';
import '../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_cubit.dart';

class ExpansionContainerSettingWidget extends StatefulWidget {
  final String? imagePath, text;
  final bool? isDoneTask;
  final Uint8List? imageMemory;
  final void Function()? onTap;
  final String? initialName;
  final String? initialLatinName;
  final int? initialTaxId;
  final int serviceId;

  const ExpansionContainerSettingWidget({
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
  State<ExpansionContainerSettingWidget> createState() =>
      _ExpansionContainerSettingWidgetState();
}

class _ExpansionContainerSettingWidgetState
    extends State<ExpansionContainerSettingWidget> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController latinNameController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.initialName ?? '',
    );

    latinNameController = TextEditingController(
      text: widget.initialLatinName ?? '',
    );

    /// 🔥 set tax from API
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
          create: (_) =>
          SelectCarModelSettingCubit()..fetchBrands(),
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
                        fontWeightIndex:
                        FontSelectionData.mediumFontFamily,
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

            BlocBuilder<SelectCarModelSettingCubit,
                SelectCarModelSettingState>(
              builder: (context, brandState) {
                final brands = brandState.brands;

                if (brandState.isLoadingBrands) {
                  return const CircularProgressIndicator();
                }

                if (brands.isEmpty) {
                  return const Text("No Brands");
                }

                return BlocBuilder<
                    DetailsContainerSettingCubit,
                    DetailsContainerSettingState>(
                  builder: (context, state) {
                    if (!state.isExpanded)
                      return const SizedBox();

                    return Column(
                      spacing: 10,
                      children: [
                        ProvServiceBrandsListView(serviceId: widget.serviceId),
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
                              EnterNameLatenNameService(nameController: nameController, latinNameController: latinNameController),
                              const SelectTaxPage()
                            ],
                          ),
                        ),

                        Column(
                          spacing: 10,
                          children: List.generate(brands.length, (index) {
                            final brand = brands[index];

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
                        ),

                        BlocListener<CreateProvServiceCubit, CreateProvServiceState>(
                          listener: (context, state) {
                            if (state is CreateProvServiceSuccess) {

                              context.read<ProvServicesCubit>()
                                  .getProvServices(serviceId: widget.serviceId);

                              nameController.clear();
                              latinNameController.clear();

                              context.read<GetTaxCubit>().clearTax();

                              AppSnackBar.showSuccess(AppLanguageKeys.success);
                            }

                            if (state is CreateProvServiceError) {
                              AppSnackBar.showError(state.error);
                            }
                          },
                          child: Column(
                            children: [
                              // 🔥 EVERYTHING (form + brands + button)
                              ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
                                onTap: () {
                                  final cubit = context.read<CreateProvServiceCubit>();

                                  if (!(_formKey.currentState?.validate() ?? false)) {
                                    AppSnackBar.showError(AppLanguageKeys.enterYourData);
                                    return;
                                  }

                                  if (cubit.brandSelection.isEmpty) {
                                    AppSnackBar.showError(AppLanguageKeys.selectPricingTypeFirst);
                                    return;
                                  }

                                  bool isValid = true;

                                  for (var entry in cubit.brandSelection.entries) {
                                    final formKey = cubit.formKeys[entry.key];

                                    if (formKey != null) {
                                      if (!(formKey.currentState?.validate() ?? false)) {
                                        isValid = false;
                                      }
                                    }
                                  }

                                  if (!isValid) {
                                    AppSnackBar.showError(AppLanguageKeys.enterYourData);
                                    return;
                                  }

                                  final taxCubit = context.read<GetTaxCubit>();

                                  cubit.createProvService(
                                    request: CreateProvServiceRequest(
                                      taxid: taxCubit.selectedTax!.taxId,
                                      name: nameController.text,
                                      latinname: latinNameController.text,
                                      brands: cubit.buildBrands(),
                                      cars: cubit.cars,
                                    ),
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