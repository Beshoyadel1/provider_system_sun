import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_prov_service_model/create_prov_service_request.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/snakbar.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/create_prov_service_cubit/create_prov_service_state.dart';
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


class ExpansionContainerSettingWidget extends StatelessWidget {
  final String? imagePath, text;
  final bool? isDoneTask;
  final Uint8List? imageMemory;
  final void Function()? onTap;

  const ExpansionContainerSettingWidget({
    super.key,
    this.imagePath,
    this.imageMemory,
    this.text,
    this.isDoneTask = false,
    this.onTap,
  });

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
      ],
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: (imageMemory == null ||
                            imageMemory!.isEmpty)
                            ? Image.asset(imagePath ?? '')
                            : Image.memory(imageMemory!,width: 50,),
                      ),
                      const SizedBox(width: 5),
                      TextInAppWidget(
                        text: text ?? '',
                        textSize: 13,
                        fontWeightIndex:
                        FontSelectionData.mediumFontFamily,
                        textColor: AppColors.darkColor,
                      ),
                    ],
                  ),
                ),
                ContainerOpenCloseTabSetting(
                  isDoneTask: isDoneTask,
                  onTap:onTap,
                )
              ],
            ),

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
                        Column(
                          children:
                          List.generate(brands.length, (index) {
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
                                brandId: brand.id??0,
                              ),
                            );
                          }),
                        ),
                        BlocListener<CreateProvServiceCubit, CreateProvServiceState>(
                          listener: (context, state) {
                            if (state is CreateProvServiceSuccess) {
                              AppSnackBar.showSuccess(AppLanguageKeys.success);
                            }

                            if (state is CreateProvServiceError) {
                              AppSnackBar.showError(state.error);
                            }
                          },
                          child: ContainerViewAllInFirstRowInDataContainerInListDataFirstScreenInternalOrders(
                              onTap: () {
                                final cubit = context.read<CreateProvServiceCubit>();
                                if (cubit.brandSelection.isEmpty) {
                                  AppSnackBar.showError(AppLanguageKeys.selectPricingTypeFirst);
                                  return;
                                }

                                bool isValid = true;

                                for (var entry in cubit.brandSelection.entries) {
                                  final brandId = entry.key;

                                  final formKey = cubit.formKeys[brandId];

                                  if (formKey != null) {
                                    final valid = formKey.currentState?.validate() ?? false;

                                    if (!valid) isValid = false;
                                  }
                                }

                                if (!isValid) {
                                  AppSnackBar.showError(AppLanguageKeys.enterYourData);
                                  return;
                                }

                                cubit.createProvService(
                                  request: CreateProvServiceRequest(
                                    taxid: 0,
                                    brands: cubit.buildBrands(),
                                    cars: cubit.cars,
                                    name: "",
                                    latinname: "",
                                  ),
                                );
                              }
                          ),
                        ),
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
