import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/screens/expansion_container_spare_parts_setting_widget.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/create_prov_service_cubit/create_prov_service_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_all_product_categories_cubit/get_all_product_categories_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_all_product_categories_cubit/get_all_product_categories_state.dart';
import '../../../../../../features/service_settings/presentation/pages/added_maintenance_and_internal_services_in_service_settings/screens/icon_car_orange_text_of_added_maintenance_and_internal_services.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_state.dart';
import 'product_branch_filter.dart';

class DataContainerInListDataCarSparePartsInServiceSettings
    extends StatelessWidget {
  final String textServiceScreen;
  final Uint8List imageMemory;

  const DataContainerInListDataCarSparePartsInServiceSettings(
      {super.key, required this.textServiceScreen, required this.imageMemory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 30,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconCarOrangeTextOfAddedMaintenanceAndInternalServices(
            text: textServiceScreen,
            imageMemory: imageMemory,
          ),
          const ProductBranchFilter(),
          BlocBuilder<GetAllProductCategoriesCubit,
              GetAllProductCategoriesState>(
            buildWhen: (previous, current) =>
                current is GetAllProductCategoriesLoading ||
                current is GetAllProductCategoriesSuccess ||
                current is GetAllProductCategoriesError,
            builder: (context, state) {
              if (state is GetAllProductCategoriesLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetAllProductCategoriesSuccess) {
                return BlocBuilder<BranchCubit, BranchState>(
                    builder: (context, branchState) {
                  final branchId = context.read<BranchCubit>().selectedBranchId;
                  return Column(
                    children: List.generate(state.categories.length, (index) {
                      final categories = state.categories[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ExpansionContainerSparePartsSettingWidget(
                          key: ValueKey('products-${categories.id}-$branchId'),
                          branchId: branchId == 0 ? null : branchId,
                          imageMemory: categories.image,
                          text: categories.getName(context),
                          serviceId: categories.id!,
                          categoryId: categories.id!,
                          isDoneTask: true,
                          onTap: () {
                            context.read<CreateProvServiceCubit>().setService(
                                  id: categories.id!,
                                );
                          },
                        ),
                      );
                    }),
                  );
                });
              }

              if (state is GetAllProductCategoriesError) {
                final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
                return Column(children: [
                  Text(state.error),
                  TextButton(
                    onPressed: context
                        .read<GetAllProductCategoriesCubit>()
                        .getAllProductCategories,
                    child: Text(ar ? 'إعادة المحاولة' : 'Retry'),
                  ),
                ]);
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
