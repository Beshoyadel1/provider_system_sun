import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/screens/design_create_spare_parts_design.dart';
import 'package:sun_web_system/features/service_settings/logic/get_products_by_category_cubit/get_products_by_category_cubit.dart';
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

class ExpansionContainerSparePartsSettingWidget extends StatefulWidget {
  final String? imagePath, text;
  final bool? isDoneTask;
  final Uint8List? imageMemory;
  final void Function()? onTap;
  final String? initialName;
  final String? initialLatinName;
  final int? initialTaxId;
  final int serviceId;
  final int categoryId;

  const ExpansionContainerSparePartsSettingWidget({
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
    required this.categoryId,
  });

  @override
  State<ExpansionContainerSparePartsSettingWidget> createState() =>
      _ExpansionContainerSparePartsSettingWidgetState();
}

class _ExpansionContainerSparePartsSettingWidgetState
    extends State<ExpansionContainerSparePartsSettingWidget> {


  Widget _buildImage() {
    // memory image
    if (widget.imageMemory != null && widget.imageMemory!.isNotEmpty) {
      return Image.memory(
        widget.imageMemory!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }

    // asset image
    if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
      return Image.asset(
        widget.imagePath!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.ac_unit,
        color: Colors.grey,
        size: 28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: _buildImage(),
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
            BlocBuilder<DetailsContainerSettingCubit, DetailsContainerSettingState>(
              builder: (context, state) {
                if (!state.isExpanded) return const SizedBox();

                return  BlocProvider(
                    create: (_) => GetProductsByCategoryCubit()
                      ..getProductsByCategory(
                        categoryId: widget.categoryId,
                      ),
                child: const DesignCreateSparePartsDesign());
              },
            ),
          ],
        ),
      ),
    );
  }
}
