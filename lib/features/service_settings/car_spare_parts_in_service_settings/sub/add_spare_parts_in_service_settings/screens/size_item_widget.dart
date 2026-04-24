import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/screens/size_controllers.dart';
import 'package:sun_web_system/features/service_settings/custom_widget/text_with_text_form_field_as_column2_widget.dart';

class SizeItemWidget extends StatelessWidget {
  final SizeControllers controllers;
  final double itemWidth;
  final VoidCallback? onDelete;
  final VoidCallback? onAdd;
  final bool showDelete;
  final String title;

  const SizeItemWidget({
    super.key,
    required this.title,
    required this.controllers,
    required this.itemWidth,
    this.onDelete,
    this.onAdd,
    this.showDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInAppWidget(
          text: title,
          textSize: 13,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 15,
                children: [
                  _item(itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.name,
                        textFormController: controllers.nameController,
                      )),
                  _item(itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.latinName,
                        textFormController: controllers.latinNameController,
                      )),
                  _item(itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.price,
                        isDigit: true,
                        textFormController: controllers.priceController,
                      )),
                  _item(itemWidth,
                      TextWithTextFormFieldAsColumn2Widget(
                        text: AppLanguageKeys.cost,
                        isDigit: true,
                        textFormController: controllers.costController,
                      )),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add, color: Colors.green),
                  ),
                  if (showDelete)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _item(double width, Widget child) {
  return SizedBox(width: width, child: child);
}