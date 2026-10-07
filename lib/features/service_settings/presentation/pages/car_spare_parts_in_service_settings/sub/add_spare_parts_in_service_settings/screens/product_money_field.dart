import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';

class ProductMoneyField extends StatelessWidget {
  final TextEditingController controller;
  final bool cost;
  const ProductMoneyField(
      {super.key, required this.controller, this.cost = false});

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText:
              cost ? (ar ? 'التكلفة' : 'Cost') : (ar ? 'السعر' : 'Price'),
          border: const OutlineInputBorder()),
      validator: (value) {
        final amount = num.tryParse(value?.trim() ?? '');
        return amount == null || !amount.isFinite || amount < 0
            ? (ar
                ? 'أدخل مبلغًا صحيحًا لا يقل عن صفر'
                : 'Enter a valid non-negative amount')
            : null;
      },
    );
  }
}
