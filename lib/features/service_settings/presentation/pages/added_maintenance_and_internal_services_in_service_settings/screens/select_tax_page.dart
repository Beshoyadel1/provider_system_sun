import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_cubit.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/get_tax_cubit/get_tax_state.dart';

class SelectTaxPage extends StatelessWidget {
  const SelectTaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetTaxCubit, GetTaxState>(
      builder: (context, state) {
        final taxCubit = context.read<GetTaxCubit>();

        if (state is GetTaxLoading) {
          return const CircularProgressIndicator();
        }

        if (state is GetTaxSuccess) {
          return DropdownButtonFormField<int>(
            value: taxCubit.selectedTax?.taxId,

            items: taxCubit.taxes.map((tax) {
              return DropdownMenuItem<int>(
                value: tax.taxId,
                child: TextInAppWidget(
                  text: "${tax.taxPercentage}%",
                  textSize: 14,
                  fontWeightIndex: FontSelectionData.regularFontFamily,
                  textColor: AppColors.darkColor,
                ),
              );
            }).toList(),

            onChanged: (value) {
              final selected = taxCubit.taxes.firstWhere(
                    (e) => e.taxId == value,
              );

              taxCubit.selectTax(selected);
            },

            validator: (value) {
              if (value == null) {
                return AppLocalizations.of(context)
                    .translate(AppLanguageKeys.enterYourData);
              }
              return null;
            },

            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.darkColor.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.darkColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.redColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                const BorderSide(color: AppColors.redColor, width: 1.5),
              ),
            ),

            hint: const TextInAppWidget(
              text: AppLanguageKeys.taxes,
              textSize: 14,
              fontWeightIndex: FontSelectionData.regularFontFamily,
              textColor: AppColors.orangeColor,
            ),

            icon: const Icon(Icons.arrow_drop_down),
          );
        }

        if (state is GetTaxError) {
          return const TextInAppWidget(text: AppLanguageKeys.enterYourData);
        }

        return const SizedBox();
      },
    );
  }
}
