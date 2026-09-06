import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/text_form_field_widget.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/presentation/validation/service_price_validation.dart';

class GeneralServicePricingWidget extends StatelessWidget {
  final bool? isUnifiedPrice;
  final ValueChanged<bool> onPricingTypeChanged;
  final TextEditingController priceController;
  final TextEditingController costController;

  const GeneralServicePricingWidget({
    super.key,
    required this.isUnifiedPrice,
    required this.onPricingTypeChanged,
    required this.priceController,
    required this.costController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: RadioListTile<bool>(
                  value: true,
                  groupValue: isUnifiedPrice,
                  activeColor: AppColors.orangeColor,
                  contentPadding: EdgeInsets.zero,
                  title: const TextInAppWidget(
                    text: AppLanguageKeys.generalUnifiedPrice,
                    textSize: 13,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                  ),
                  onChanged: (value) {
                    if (value != null) onPricingTypeChanged(value);
                  },
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: RadioListTile<bool>(
                  value: false,
                  groupValue: isUnifiedPrice,
                  activeColor: AppColors.orangeColor,
                  contentPadding: EdgeInsets.zero,
                  title: const TextInAppWidget(
                    text: AppLanguageKeys.priceByBrandAndModel,
                    textSize: 13,
                    fontWeightIndex: FontSelectionData.mediumFontFamily,
                  ),
                  onChanged: (value) {
                    if (value != null) onPricingTypeChanged(value);
                  },
                ),
              ),
            ),
          ],
        ),
        if (isUnifiedPrice == true) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormFieldWidget(
                  textFormController: priceController,
                  hintText: AppLanguageKeys.price,
                  fillColor: AppColors.transparent,
                  borderColor: AppColors.darkColor.withOpacity(0.2),
                  hintTextSize: 12,
                  hintTextColor: AppColors.orangeColor,
                  textSize: 15,
                  isDigit: true,
                  showValidationMessage: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLanguageKeys.enterYourData;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormFieldWidget(
                  textFormController: costController,
                  hintText: AppLanguageKeys.cost,
                  fillColor: AppColors.transparent,
                  borderColor: AppColors.darkColor.withOpacity(0.2),
                  hintTextSize: 12,
                  hintTextColor: AppColors.orangeColor,
                  textSize: 15,
                  isDigit: true,
                  showValidationMessage: true,
                  validator: (value) {
                    return validateCostLessThanPrice(
                      costText: value,
                      priceText: priceController.text,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
