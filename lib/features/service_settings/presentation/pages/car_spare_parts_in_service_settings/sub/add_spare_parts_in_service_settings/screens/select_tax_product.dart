import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_state.dart';
import 'product_form_widgets.dart';

class SelectTaxProduct extends StatelessWidget {
  const SelectTaxProduct({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<GetTaxCubit, GetTaxState>(
        builder: (context, state) {
          final cubit = context.read<GetTaxCubit>();
          final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
          if (state is GetTaxLoading || state is GetTaxInitial) {
            return ProductFieldLabel(
              label: AppLanguageKeys.taxes,
              child: SizedBox(
                height: ProductFormStyle.fieldHeight(context),
                child: const Center(
                    child: SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.orangeColor),
                )),
              ),
            );
          }
          if (state is GetTaxError) {
            return ProductFieldLabel(
              label: AppLanguageKeys.taxes,
              child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.orangeColor),
                onPressed: cubit.getTax,
                child: TextInAppWidget(
                  text: ar
                      ? 'تعذر تحميل الضرائب، أعد المحاولة'
                      : 'Unable to load taxes. Retry',
                  textSize: 12,
                  textColor: AppColors.orangeColor,
                ),
              ),
            );
          }
          return ProductDropdownField<int>(
            label: AppLanguageKeys.taxes,
            value: cubit.selectedTax?.taxId,
            items: [
              for (final tax in cubit.taxes)
                DropdownMenuItem(
                  value: tax.taxId,
                  child: TextInAppWidget(
                      text: '${tax.taxPercentage}%',
                      textSize: 13,
                      textColor: AppColors.darkColor),
                )
            ],
            onChanged: (value) {
              if (value == null) return;
              cubit.selectTax(
                  cubit.taxes.firstWhere((tax) => tax.taxId == value));
            },
            validator: (value) =>
                value == null ? (ar ? 'اختر الضريبة' : 'Select tax') : null,
          );
        },
      );
}
