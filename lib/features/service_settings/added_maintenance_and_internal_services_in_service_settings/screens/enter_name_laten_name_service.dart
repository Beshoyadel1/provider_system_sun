import 'package:flutter/cupertino.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../core/theming/colors.dart';

class EnterNameLatenNameService extends StatelessWidget {
  final TextEditingController nameController,latinNameController;
  const EnterNameLatenNameService({super.key,required this.nameController,required this.latinNameController});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
          child: TextFormFieldWidget(
            textFormController: nameController,
            hintText: AppLanguageKeys.serviceNameAr,
            fillColor: AppColors.transparent,
            borderColor: AppColors.darkColor.withOpacity(0.2),
            hintTextSize: 12,
            hintTextColor: AppColors.orangeColor,
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
            textFormController: latinNameController,
            fillColor: AppColors.transparent,
            borderColor: AppColors.darkColor.withOpacity(0.2),
            hintTextSize: 12,
            hintTextColor: AppColors.orangeColor,
            textSize: 15,
            hintText: AppLanguageKeys.serviceNameEn,
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
