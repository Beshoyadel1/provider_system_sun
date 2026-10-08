import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'product_form_widgets.dart';

class IsNewSwitch extends StatelessWidget {
  const IsNewSwitch(
      {super.key, required this.onChanged, required this.initialValue});
  final ValueChanged<bool> onChanged;
  final bool initialValue;

  @override
  Widget build(BuildContext context) => ProductToggleField(
        label: LanguageCubit.get(context).isAllAppLanguageArabic
            ? 'الحالة'
            : 'Condition',
        value: initialValue,
        onChanged: onChanged,
        trueText: AppLanguageKeys.isNew,
        falseText: AppLanguageKeys.isNotNew,
      );
}
