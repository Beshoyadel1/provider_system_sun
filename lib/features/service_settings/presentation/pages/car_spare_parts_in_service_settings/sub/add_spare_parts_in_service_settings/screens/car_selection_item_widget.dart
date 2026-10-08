import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/memory_image_with_fallback.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/car_selection_cubit/CarSelectionCubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/select_car_model_setting_cubit/select_car_model_setting_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/select_car_model_setting_cubit/select_car_model_setting_state.dart';
import 'car_selection_controller.dart';
import 'product_form_widgets.dart';

class CarSelectionItemWidget extends StatefulWidget {
  const CarSelectionItemWidget({
    super.key,
    required this.controller,
    this.onAdd,
    this.onDelete,
    this.onSelectionChanged,
    this.unavailableBrandIds = const <int>{},
    this.isAllBrandsSelectedElsewhere = false,
    this.showDelete = true,
  });
  final CarSelectionController controller;
  final VoidCallback? onAdd, onDelete, onSelectionChanged;
  final Set<int> unavailableBrandIds;
  final bool isAllBrandsSelectedElsewhere, showDelete;

  @override
  State<CarSelectionItemWidget> createState() => _CarSelectionItemWidgetState();
}

class _CarSelectionItemWidgetState extends State<CarSelectionItemWidget> {
  String? _modelsError;

  Future<void> _selectBrand(int value) async {
    final carCubit = context.read<CarSelectionCubit>();
    setState(() {
      _modelsError = null;
      widget.controller.isAllBrandsSelected = value == -1;
      widget.controller.brandId = value == -1 ? null : value;
      widget.controller.selectedModelIds.clear();
      widget.controller.models.clear();
      widget.controller.isLoading = value != -1;
    });
    widget.onSelectionChanged?.call();
    if (value == -1) return;
    try {
      final models = await carCubit.getModels(value);
      if (!mounted || widget.controller.brandId != value) return;
      setState(() {
        widget.controller.models = models;
        widget.controller.isLoading = false;
      });
    } catch (error) {
      if (!mounted || widget.controller.brandId != value) return;
      setState(() {
        widget.controller.isLoading = false;
        _modelsError = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.cardStroke),
        borderRadius: BorderRadius.circular(15),
      ),
      child:
          BlocBuilder<SelectCarModelSettingCubit, SelectCarModelSettingState>(
        builder: (context, state) {
          final availableBrands = state.brands.where((brand) {
            if (widget.isAllBrandsSelectedElsewhere) {
              return brand.id == widget.controller.brandId;
            }
            return brand.id == widget.controller.brandId ||
                !widget.unavailableBrandIds.contains(brand.id);
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.isLoadingBrands)
                const LinearProgressIndicator(color: AppColors.orangeColor)
              else
                ProductDropdownField<int>(
                  label: AppLanguageKeys.selectCarBrand,
                  value: widget.controller.isAllBrandsSelected
                      ? -1
                      : widget.controller.brandId,
                  items: [
                    if (widget.controller.isAllBrandsSelected ||
                        (!widget.isAllBrandsSelectedElsewhere &&
                            widget.unavailableBrandIds.isEmpty))
                      const DropdownMenuItem<int>(
                        value: -1,
                        child: TextInAppWidget(
                            text: AppLanguageKeys.allBrands,
                            textSize: 13,
                            textColor: AppColors.darkColor),
                      ),
                    for (final brand in availableBrands)
                      DropdownMenuItem<int>(
                        value: brand.id,
                        child: Row(children: [
                          MemoryImageWithFallback(
                              bytes: brand.image,
                              width: 22,
                              height: 22,
                              fallback: const Icon(
                                  Icons.directions_car_outlined,
                                  size: 20,
                                  color: AppColors.darkGreyColor)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: TextInAppWidget(
                                  text: brand.getName(context),
                                  textSize: 13,
                                  textColor: AppColors.darkColor,
                                  maxLines: 1,
                                  isEllipsisTextOverflow: true)),
                        ]),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) _selectBrand(value);
                  },
                ),
              if (widget.controller.brandId != null) ...[
                const SizedBox(height: 12),
                if (widget.controller.isLoading)
                  const LinearProgressIndicator(color: AppColors.orangeColor)
                else if (_modelsError != null)
                  TextButton(
                    onPressed: () => _selectBrand(widget.controller.brandId!),
                    child: TextInAppWidget(
                        text: ar
                            ? 'تعذر تحميل الموديلات، أعد المحاولة'
                            : 'Unable to load models. Retry',
                        textSize: 12,
                        textColor: AppColors.orangeColor),
                  )
                else if (widget.controller.models.isEmpty)
                  TextInAppWidget(
                      text: ar ? 'لا توجد موديلات' : 'No models',
                      textSize: 12,
                      textColor: AppColors.darkGreyColor)
                else
                  ProductFieldLabel(
                    label: AppLanguageKeys.selectCarModel,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.cardStroke),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 192),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            _modelCheckbox(
                              AppLanguageKeys.allModels,
                              widget.controller.selectedModelIds.length ==
                                  widget.controller.models.length,
                              (selected) => setState(() {
                                widget.controller.selectedModelIds =
                                    selected == true
                                        ? widget.controller.models
                                            .map((model) => model.id!)
                                            .toList()
                                        : [];
                              }),
                            ),
                            const Divider(
                                height: 1, color: AppColors.cardStroke),
                            for (final model in widget.controller.models)
                              _modelCheckbox(
                                model.name ?? '',
                                widget.controller.selectedModelIds
                                    .contains(model.id),
                                (selected) => setState(() {
                                  if (selected == true) {
                                    widget.controller.selectedModelIds
                                        .add(model.id!);
                                  } else {
                                    widget.controller.selectedModelIds
                                        .remove(model.id);
                                  }
                                }),
                              ),
                          ]),
                        ),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                  tooltip: ar ? 'إضافة ماركة' : 'Add brand',
                  onPressed: widget.onAdd,
                  icon: const Icon(Icons.add_circle_outline,
                      color: AppColors.orangeColor, size: 22),
                ),
                if (widget.showDelete)
                  IconButton(
                    tooltip: ar ? 'حذف الماركة' : 'Remove brand',
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete_outline,
                        color: AppColors.redColor, size: 22),
                  ),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _modelCheckbox(
          String name, bool selected, ValueChanged<bool?> onChanged) =>
      Material(
        type: MaterialType.transparency,
        child: CheckboxListTile(
          value: selected,
          onChanged: onChanged,
          activeColor: AppColors.orangeColor,
          checkColor: AppColors.whiteColor,
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
          controlAffinity: ListTileControlAffinity.leading,
          title: TextInAppWidget(
              text: name,
              textSize: 13,
              textColor: AppColors.darkColor,
              maxLines: 2,
              isEllipsisTextOverflow: true),
        ),
      );
}
