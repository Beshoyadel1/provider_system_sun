import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';

class IsNewSwitch extends StatefulWidget {
  final Function(bool value) onChanged;
  final bool initialValue;

  const IsNewSwitch({
    super.key,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  State<IsNewSwitch> createState() => _IsNewSwitchState();
}

class _IsNewSwitchState extends State<IsNewSwitch> {
  late bool isNew;

  @override
  void initState() {
    super.initState();
    isNew = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant IsNewSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      isNew = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: isNew,
          activeColor: AppColors.orangeColor,
          onChanged: (value) {
            setState(() {
              isNew = value;
            });

            widget.onChanged(value);
          },
        ),
        TextInAppWidget(
          text: isNew
              ? AppLanguageKeys.isNew
              : AppLanguageKeys.isNotNew,
          textSize: 13,
        ),
      ],
    );
  }
}