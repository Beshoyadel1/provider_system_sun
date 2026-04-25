import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/custom_widget/text_empty_view_data.dart';
import 'package:sun_web_system/features/service_settings/custom_widget/container_car_spare_parts_details_widget.dart';
import 'package:sun_web_system/features/service_settings/logic/get_products_by_category_cubit/get_products_by_category_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/get_products_by_category_cubit/get_products_by_category_state.dart';

class DesignCreateSparePartsDesign extends StatelessWidget {

  const DesignCreateSparePartsDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetProductsByCategoryCubit, GetProductsByCategoryState>(
      builder: (context, state) {
        final cubit = context.read<GetProductsByCategoryCubit>();

        final data = cubit.products;

        if (state is GetProductsByCategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (data.isEmpty) {
          return const TextEmptyViewData();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;

            int itemsPerRow = 4;
            if (width < 1200) itemsPerRow = 3;
            if (width < 800) itemsPerRow = 2;
            if (width < 500) itemsPerRow = 1;

            int rowCount = (data.length / itemsPerRow).ceil();

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rowCount,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, rowIndex) {
                int startIndex = rowIndex * itemsPerRow;

                return Row(
                  children: List.generate(itemsPerRow, (colIndex) {
                    int itemIndex = startIndex + colIndex;

                    if (itemIndex >= data.length) {
                      return const Expanded(child: SizedBox());
                    }

                    final item = data[itemIndex];

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ContainerCarSparePartsDetailsWidget(
                          nameCategoryProduct: item.getCategoryName(context),
                          nameBrandCar: item.getBrandName(context),
                          nameProduct: item.getName(context),
                          stock: (item.inStock ?? 0).toString(),
                          priceProduct: (item.price ?? 0).toString(),
                          imageProductBytes: item.image,
                          imageCarBrandBytes: item.brands.isNotEmpty
                              ? item.brands.first.image
                              : null,
                        ),
                      ),
                    );
                  }),
                );
              },
            );
          },
        );
      },
    );
  }
}
