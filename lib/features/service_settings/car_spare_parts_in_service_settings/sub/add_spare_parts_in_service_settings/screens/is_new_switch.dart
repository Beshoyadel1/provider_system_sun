import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';

class IsNewSwitch extends StatefulWidget {
  const IsNewSwitch({super.key, required this.onChanged});

  final Function(bool value) onChanged;

  @override
  State<IsNewSwitch> createState() => _IsNewSwitchState();
}

class _IsNewSwitchState extends State<IsNewSwitch> {
  bool isNew = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.isNew,
          textSize: 11,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),

        Row(
          children: [
            Switch(
              value: isNew,
              activeColor: AppColors.greenColor,
              onChanged: (value) {
                setState(() {
                  isNew = value;
                });

                widget.onChanged(value);
              },
            ),

            TextInAppWidget(
            text: isNew ? AppLanguageKeys.isNew : AppLanguageKeys.isNotNew,
              textSize: 13,
            ),
          ],
        ),
      ],
    );
  }
}