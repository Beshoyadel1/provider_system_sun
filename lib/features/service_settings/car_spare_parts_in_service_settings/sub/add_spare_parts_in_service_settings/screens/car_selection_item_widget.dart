import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/features/service_settings/logic/car_selection_cubit/CarSelectionCubit.dart';
import 'package:sun_web_system/features/service_settings/logic/get_all_product_categories_cubit/get_all_product_categories_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/get_all_product_categories_cubit/get_all_product_categories_state.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/logic/select_car_model_setting_cubit/select_car_model_setting_state.dart';
import 'car_selection_controller.dart';

import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';


class CarSelectionItemWidget extends StatefulWidget {
  final CarSelectionController controller;
  final VoidCallback? onAdd;
  final VoidCallback? onDelete;
  final bool showDelete;

  const CarSelectionItemWidget({
    super.key,
    required this.controller,
    this.onAdd,
    this.onDelete,
    this.showDelete = true,
  });

  @override
  State<CarSelectionItemWidget> createState() =>
      _CarSelectionItemWidgetState();
}

class _CarSelectionItemWidgetState extends State<CarSelectionItemWidget> {
  @override
  Widget build(BuildContext context) {
    final carCubit = context.read<CarSelectionCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.carStatus,
          textSize: 11,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),

        const SizedBox(height: 10),

        Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: BlocBuilder<SelectCarModelSettingCubit,
              SelectCarModelSettingState>(
            builder: (context, state) {
              if (state.isLoadingBrands) {
                return const CircularProgressIndicator();
              }

              final brands = state.brands;

              return Column(
                spacing: 15,
                children: [
                  BlocBuilder<GetAllProductCategoriesCubit, GetAllProductCategoriesState>(
                    builder: (context, state) {
                      final cubit = context.read<GetAllProductCategoriesCubit>();

                      if (state is GetAllProductCategoriesLoading) {
                        return const CircularProgressIndicator();
                      }

                      if (state is GetAllProductCategoriesSuccess) {
                        return SizedBox(
                          height: 35,
                          child: DropdownButtonFormField<int>(
                            isDense: true,
                            isExpanded: true,
                            value: widget.controller.categoryId,

                            items: cubit.categories.map((cat) {
                              return DropdownMenuItem<int>(
                                value: cat.id,
                                child: Text(
                                  cat.getName(context),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),

                            onChanged: (value) {
                              final selected = cubit.categories.firstWhere(
                                    (e) => e.id == value,
                              );
                              setState(() {
                                widget.controller.categoryId = selected.id;
                                widget.controller.categoryName =
                                    selected.getName(context);
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return '';
                              }
                              return null;
                            },
                            decoration: _inputDecoration(),
                            icon: const Icon(Icons.arrow_drop_down),
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                  SizedBox(
                    height: 35,
                    child: DropdownButtonFormField<int>(
                      isDense: true,
                      isExpanded: true,
                      value: widget.controller.brandId,

                      items: brands.map((brand) {
                        return DropdownMenuItem<int>(
                          value: brand.id,
                          child: Row(
                            children: [
                              brand.image != null
                                  ? Image.memory(
                                brand.image!,
                                width: 25,
                                height: 25,
                              )
                                  : const Icon(Icons.directions_car, size: 20),

                              const SizedBox(width: 8),

                              Expanded(
                                child: TextInAppWidget(
                                  text: brand.getName(context),
                                  textSize: 12,
                                  fontWeightIndex:
                                  FontSelectionData.regularFontFamily,
                                  textColor: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      onChanged: (value) async {
                        if (value == null) return;

                        setState(() {
                          widget.controller.brandId = value;
                          widget.controller.modelId = null;
                          widget.controller.isLoading = true;
                        });

                        final models =
                        await carCubit.getModels(value);

                        setState(() {
                          widget.controller.models = models;
                          widget.controller.isLoading = false;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return '';
                        }
                        return null;
                      },
                      decoration: _inputDecoration(),
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  widget.controller.isLoading
                      ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                      : SizedBox(
                    height: 35,
                    child: DropdownButtonFormField<int>(
                      isDense: true,
                      isExpanded: true,
                      value: widget.controller.modelId,

                      items: widget.controller.models.map((model) {
                        return DropdownMenuItem<int>(
                          value: model.id,
                          child: Row(
                            children: [
                              model.image != null
                                  ? Image.memory(
                                model.image!,
                                width: 25,
                                height: 25,
                              )
                                  : const Icon(Icons.car_repair,
                                  size: 20),

                              const SizedBox(width: 8),

                              Expanded(
                                child: TextInAppWidget(
                                  text: model.name ?? "",
                                  textSize: 12,
                                  fontWeightIndex:
                                  FontSelectionData
                                      .regularFontFamily,
                                  textColor: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      onChanged: widget.controller.brandId == null
                          ? null
                          : (value) {
                        setState(() {
                          widget.controller.modelId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return '';
                        }
                        return null;
                      },
                      decoration: _inputDecoration(),
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: widget.onAdd,
                        icon: const Icon(Icons.add, color: Colors.green),
                      ),
                      if (widget.showDelete)
                        IconButton(
                          onPressed: widget.onDelete,
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),

      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.transparent,
      contentPadding: const EdgeInsets.all(5),

      errorStyle: const TextStyle(
        height: 0.01,
        fontSize: 1,
        color: AppColors.redColor,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppColors.darkColor.withOpacity(0.2),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: AppColors.darkColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.redColor),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.redColor,
          width: 1.5,
        ),
      ),
    );
  }
}