import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/car_selection_cubit/CarSelectionCubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/select_car_model_setting_cubit/select_car_model_setting_state.dart';
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
  State<CarSelectionItemWidget> createState() => _CarSelectionItemWidgetState();
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
                  Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextInAppWidget(
                        text: AppLanguageKeys.selectCarBrand,
                        textSize: 11,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                        textColor: AppColors.blackColor,
                      ),
                      SizedBox(
                        height: 35,
                        child:DropdownButtonFormField<int>(
                          isDense: true,
                          isExpanded: true,
                          value: widget.controller.isAllBrandsSelected
                              ? -1
                              : widget.controller.brandId,
                          items: [
                            const DropdownMenuItem<int>(
                              value: -1,
                              child: TextInAppWidget(
                                text: AppLanguageKeys.allBrands,
                                textSize: 11,
                                fontWeightIndex: FontSelectionData.regularFontFamily,
                                textColor: AppColors.blackColor,
                              ),
                            ),
                            ...brands.map((brand) {
                              return DropdownMenuItem<int>(
                                value: brand.id,
                                child: Row(
                                  children: [
                                    brand.image != null
                                        ? Image.memory(brand.image!, width: 25, height: 25)
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
                            }),
                          ],
                          onChanged: (value) async {
                            if (value == null) return;

                            if (value == -1) {
                              setState(() {
                                widget.controller.isAllBrandsSelected = true;
                                widget.controller.brandId = null;
                                widget.controller.selectedModelIds.clear();
                                widget.controller.models.clear();
                              });
                              return;
                            }

                            setState(() {
                              widget.controller.isAllBrandsSelected = false;
                              widget.controller.brandId = value;
                              widget.controller.selectedModelIds.clear();
                              widget.controller.models.clear();
                              widget.controller.isLoading = true;
                            });

                            final models = await carCubit.getModels(value);

                            setState(() {
                              widget.controller.models = models;
                              widget.controller.isLoading = false;
                            });
                          },
                          decoration: _inputDecoration(),
                          icon: const Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ],
                  ),

                  if (widget.controller.brandId == null)
                    const SizedBox()

                  else if (widget.controller.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )

                  else if (widget.controller.models.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "لا توجد موديلات",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )

                    else
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextInAppWidget(
                            text: AppLanguageKeys.selectCarModel,
                            textSize: 11,
                            fontWeightIndex: FontSelectionData.regularFontFamily,
                            textColor: AppColors.blackColor,
                          ),

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  activeColor: AppColors.orangeColor,
                                  value: widget.controller.selectedModelIds.length ==
                                      widget.controller.models.length,
                                  dense: true,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: const TextInAppWidget(
                                      text:AppLanguageKeys.allModels,
                                    textSize: 13,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        widget.controller.selectedModelIds = widget.controller.models
                                            .map((e) => e.id!)
                                            .toList();
                                      } else {
                                        widget.controller.selectedModelIds.clear();
                                      }
                                    });
                                  },
                                ),

                                const Divider(),

                                ...widget.controller.models.map((model) {
                                  final isSelected = widget.controller.selectedModelIds.contains(model.id);

                                  return CheckboxListTile(
                                    activeColor: AppColors.orangeColor,
                                    value: isSelected,
                                    dense: true,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    title: Text(model.name ?? ""),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          widget.controller.selectedModelIds.add(model.id!);
                                        } else {
                                          widget.controller.selectedModelIds.remove(model.id);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
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