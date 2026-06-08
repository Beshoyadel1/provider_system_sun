import 'package:flutter/cupertino.dart';
import 'package:sun_web_system/core/pages_widgets/text_form_field_widget.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';

class TextWithTextFormField extends StatelessWidget {
  final String text, hint;
  final List<String>? options;
  final TextEditingController textFormController = TextEditingController();
  final int? maxLines;
  final double? textFormWidth, textFormHeight, borderRadius, textSize;

  TextWithTextFormField(
      {super.key,
      required this.text,
      required this.hint,
      this.options,
      this.maxLines,
      this.textFormWidth,
      this.textFormHeight,
      this.borderRadius,
      this.textSize});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        TextInAppWidget(
          text: text,
          textSize: 11,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),
        TextFormFieldWidget(
          textFormController: textFormController,
          fillColor: AppColors.transparent,
          borderColor: AppColors.darkColor.withOpacity(0.2),
          hintText: hint,
          hintTextSize: 11,
          hintTextColor: AppColors.darkColor.withOpacity(0.4),
          textSize: 11,
          contentPadding: const EdgeInsetsGeometry.all(5),
          textFormHeight:
              maxLines != null && maxLines! > 1 ? null : (textFormHeight ?? 35),
          maxLines: maxLines,
          textFormWidth: textFormWidth,
          focusedBorderRadius: BorderRadius.circular(borderRadius ?? 15),
          enabledBorderRadius: BorderRadius.circular(borderRadius ?? 15),
        ),
      ],
    );
  }
}
