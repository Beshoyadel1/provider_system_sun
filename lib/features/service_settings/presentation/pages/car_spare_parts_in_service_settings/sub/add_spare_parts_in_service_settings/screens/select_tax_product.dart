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

class SelectTaxProduct extends StatelessWidget {
  const SelectTaxProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextInAppWidget(
          text: AppLanguageKeys.taxes,
          textSize: 11,
          fontWeightIndex: FontSelectionData.regularFontFamily,
          textColor: AppColors.blackColor,
        ),
        BlocBuilder<GetTaxCubit, GetTaxState>(
          builder: (context, state) {
            final taxCubit = context.read<GetTaxCubit>();

            if (state is GetTaxLoading) {
              return const CircularProgressIndicator();
            }

            if (state is GetTaxSuccess) {
              return SizedBox(
                height: 35,
                child: DropdownButtonFormField<int>(
                  isDense: true,
                  value: taxCubit.selectedTax?.taxId,

                  items: taxCubit.taxes.map((tax) {
                    return DropdownMenuItem<int>(
                      value: tax.taxId,
                      child: TextInAppWidget(
                        text: "${tax.taxPercentage}%",
                        textSize: 13,
                        fontWeightIndex: FontSelectionData.regularFontFamily,
                        textColor: AppColors.blackColor,
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
                      return '';
                    }
                    return null;
                  },

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.transparent,
                    contentPadding: const EdgeInsets.all(5),

                    errorStyle: const TextStyle(
                        height: 0.01,
                        fontSize: 1,
                        color: AppColors.redColor
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.darkColor.withOpacity(0.2),
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.darkColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),

                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.redColor),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.redColor,
                        width: 1.5,
                      ),
                    ),
                  ),

                  icon: const Icon(Icons.arrow_drop_down),
                ),
              );
            }

            if (state is GetTaxError) {
              return const Text("Error loading taxes");
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}