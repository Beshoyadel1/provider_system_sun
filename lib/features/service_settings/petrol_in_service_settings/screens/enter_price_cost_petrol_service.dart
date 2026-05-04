import 'package:flutter/cupertino.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../core/theming/colors.dart';

class EnterPriceCostPetrolService extends StatelessWidget {
  final TextEditingController priceController,costController;
  const EnterPriceCostPetrolService({super.key,required this.priceController,required this.costController});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
          child: TextFormFieldWidget(
            textFormController: priceController,
            hintText: AppLanguageKeys.price,
            fillColor: AppColors.transparent,
            borderColor: AppColors.darkColor.withOpacity(0.2),
            hintTextSize: 12,
            hintTextColor: AppColors.orangeColor,
            isDigit: true,
            textSize: 15,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLanguageKeys.enterYourData;
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: TextFormFieldWidget(
            textFormController: costController,
            fillColor: AppColors.transparent,
            borderColor: AppColors.darkColor.withOpacity(0.2),
            hintTextSize: 12,
            hintTextColor: AppColors.orangeColor,
            textSize: 15,
            isDigit: true,
            hintText: AppLanguageKeys.cost,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLanguageKeys.enterYourData;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
