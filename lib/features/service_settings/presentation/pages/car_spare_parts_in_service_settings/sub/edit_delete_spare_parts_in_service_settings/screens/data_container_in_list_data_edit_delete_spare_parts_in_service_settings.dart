import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/delete_product_cubit/delete_product_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/first_row_in_data_container_in_list_data_edit_delete_spare_parts_in_service_settings.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import '../../../../../../../../core/language/language_constant.dart';
import '../../../../../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../../../../../core/theming/text_styles.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/add_spare_parts_in_service_settings.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/brand_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/cost_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/stock_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/text_id_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/sizes_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/categories_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/price_of_spare_parts.dart';
import '../../../../../../../../features/service_settings/presentation/pages/car_spare_parts_in_service_settings/sub/edit_delete_spare_parts_in_service_settings/screens/text_description_of_spare_parts.dart';

class DataContainerInListDataEditDeleteSparePartsInServiceSettings
    extends StatelessWidget {
  final ProductModelGetProductsByCategory product;

  const DataContainerInListDataEditDeleteSparePartsInServiceSettings({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocProvider(
          create: (_) => DeleteProductCubit(),
          child: Builder(
            builder: (context) {
              return FirstRowInDataContainerInListDataEditDeleteSparePartsInServiceSettings(
                nameCategory: product.category?.getName(context) ?? "",
                imageProduct: product.image,
                nameProduct: product.getName(context),
                onTapDelete: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      return BlocProvider.value(
                        value: context.read<DeleteProductCubit>(),
                        child: BlocConsumer<DeleteProductCubit, DeleteProductState>(
                          listener: (context, state) {
                            if (state is DeleteProductSuccess) {
                              Navigator.pop(dialogContext);
                              AppSnackBar.showSuccess(AppLanguageKeys.success);
                              Navigator.pop(context, true);
                            }

                            if (state is DeleteProductError) {
                              AppSnackBar.showError(state.error);
                            }
                          },
                          builder: (context, state) {
                            final isLoading = state is DeleteProductLoading;

                            return AlertDialog(
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
                                  onPressed: isLoading
                                      ? null
                                      : () => Navigator.pop(dialogContext),
                                  child: const TextInAppWidget(
                                    text: AppLanguageKeys.cancel,
                                    textSize: 14,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.redColor,
                                  ),
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                    context
                                        .read<DeleteProductCubit>()
                                        .deleteProduct(product.id);
                                  },
                                  child: isLoading
                                      ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                      : const TextInAppWidget(
                                    textSize: 14,
                                    text: AppLanguageKeys.delete,
                                    textColor: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                onTapEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddSparePartsInServiceSettings(
                        product: product,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        TextIdOfSpareParts(id: product.id.toString()),
        TextDescriptionOfSpareParts(
          description: product.getDescription(context),
        ),
        PriceOfSpareParts(
          price: (product.price ?? 0).toString(),
        ),
        CostOfSpareParts(cost: (product.cost ?? 0).toString()),
        StockOfSpareParts(stock: product.inStock.toString()),
        CategoriesOfSpareParts(
          categoryName: product.category?.getName(context) ?? "",
        ),
        BrandOfSpareParts(
          brands: product.brands,
        ),
        if (product.sizes.isNotEmpty)
          SizesOfSpareParts(
            sizes: product.sizes,
          ),
      ],
    );
  }
}
