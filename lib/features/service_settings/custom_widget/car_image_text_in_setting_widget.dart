import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/pages_widgets/text_form_field_widget.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/fonts.dart';
import '../../../../../core/theming/text_styles.dart';

class CarImageTextInSettingWidget extends StatefulWidget {
  final String imagePath, text;

  const CarImageTextInSettingWidget({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  State<CarImageTextInSettingWidget> createState() =>
      _CarImageTextInSettingWidgetState();
}

class _CarImageTextInSettingWidgetState
    extends State<CarImageTextInSettingWidget> {
  late TextEditingController textFormController2;

  @override
  void initState() {
    super.initState();
    textFormController2 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Column(
            spacing: 5,
            children: [
              Image.asset(widget.imagePath),
              TextInAppWidget(
                text: widget.text,
                textSize: 10,
                fontWeightIndex: FontSelectionData.regularFontFamily,
                textColor: AppColors.darkColor,
              ),
            ],
          ),
          Expanded(
            child: TextFormFieldWidget(
              textFormController: textFormController2,
              fillColor: AppColors.transparent,
              borderColor: AppColors.darkColor.withOpacity(0.2),
              hintText: AppLanguageKeys.sar,
              hintTextSize: 10,
              hintTextColor: AppColors.orangeColor,
              textSize: 10,
              textFormWidth: 200,
              textFormHeight: 35,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
