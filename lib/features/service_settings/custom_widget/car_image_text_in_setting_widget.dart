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
    return SizedBox(
      height: 40, // 🔥 يمنع overflow نهائي
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.imagePath,
                  width: 50,
                 // height: 20,
                ),
                const SizedBox(height: 2),
                TextInAppWidget(
                  text: widget.text,
                  textSize: 9,
                  fontWeightIndex:
                  FontSelectionData.regularFontFamily,
                  textColor: AppColors.darkColor,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          /// RIGHT (input)
          Expanded(
            child: SizedBox(
              height: 35,
              child: TextFormFieldWidget(
                textFormController: textFormController2,
                fillColor: AppColors.transparent,
                borderColor: AppColors.darkColor.withOpacity(0.2),
                hintText: AppLanguageKeys.sar,
                hintTextSize: 10,
                hintTextColor: AppColors.orangeColor,
                textSize: 10,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
