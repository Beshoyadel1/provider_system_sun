import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';

class CarImageTextInSettingWidget extends StatelessWidget {
  final String text;
  final int modelId;
  final int brandId;
  final Uint8List? imageMemory;
  final TextEditingController priceController;
  final TextEditingController costController;

  const CarImageTextInSettingWidget({
    super.key,
    required this.text,
    required this.modelId,
    required this.brandId,
    required this.priceController,
    required this.costController,
    this.imageMemory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            _buildImage(),
            const SizedBox(height: 2),
            TextInAppWidget(
              text: text,
              textSize: 9,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.darkColor,
            ),
          ],
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Row(
            children: [
              /// PRICE
              Expanded(
                child: TextFormFieldWidget(
                  hintText: AppLanguageKeys.price,
                  textFormController: priceController,
                  fillColor: AppColors.transparent,
                  borderColor: AppColors.darkColor.withOpacity(0.2),
                  hintTextSize: 12,
                  hintTextColor: AppColors.orangeColor,
                  textSize: 15,
                  isDigit: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLanguageKeys.addAllRequiredFieldsKey;
                    }
                    if (double.tryParse(value) == null) {
                      return "Enter valid number";
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(width: 8),

              /// COST
              Expanded(
                child: TextFormFieldWidget(
                  hintText: AppLanguageKeys.cost,
                  textFormController: costController,
                  fillColor: AppColors.transparent,
                  borderColor: AppColors.darkColor.withOpacity(0.2),
                  hintTextSize: 12,
                  hintTextColor: AppColors.orangeColor,
                  textSize: 15,
                  isDigit: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLanguageKeys.addAllRequiredFieldsKey;
                    }
                    if (double.tryParse(value) == null) {
                      return "Enter valid number";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (imageMemory != null && imageMemory!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.memory(
          imageMemory!,
          width: 50,
          height: 30,
          fit: BoxFit.cover,
        ),
      );
    }

    return const Icon(Icons.directions_car, size: 28, color: Colors.grey);
  }
}
