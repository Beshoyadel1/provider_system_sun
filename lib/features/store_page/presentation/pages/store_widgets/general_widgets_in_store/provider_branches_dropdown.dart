import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/setup_git_it.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_state.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';

class ProviderBranchesDropdown extends StatelessWidget {
  const ProviderBranchesDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchCubit, BranchState>(
      bloc: getIt<BranchCubit>(),
      builder: (context, state) {
        final cubit = getIt<BranchCubit>();

        final List<DropdownMenuItem<int>> items = [
          const DropdownMenuItem<int>(
            value: 0,
            child: TextInAppWidget(
              text: AppLanguageKeys.allBranches,
              textSize: 14,
              textColor: AppColors.orangeColor,
              fontWeightIndex:
              FontSelectionData.regularFontFamily,
            ),
          ),
        ];

        for (final branch in cubit.branches) {
          final branchId = branch.branchId;

          if (branchId == null || branchId == 0) {
            continue;
          }

          if (items.any(
                (item) => item.value == branchId,
          )) {
            continue;
          }

          items.add(
            DropdownMenuItem<int>(
              value: branchId,
              child: TextInAppWidget(
                text: branch.getBranchName(context),
                textSize: 14,
                textColor: AppColors.orangeColor,
                fontWeightIndex:
                FontSelectionData.regularFontFamily,
              ),
            ),
          );
        }

        final bool valueExists = items.any(
              (item) => item.value == cubit.selectedBranchId,
        );

        final int selectedValue =
        valueExists ? cubit.selectedBranchId : 0;

        return Container(
          width: double.infinity,
          height: 42,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: AppColors.orangeColor,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedValue,
              items: items,
              isExpanded: true,
              focusColor: AppColors.orangeColor,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.whiteColor,
              ),

              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),

              dropdownColor: AppColors.whiteColor,

              borderRadius: BorderRadius.circular(10),

              onChanged: (value) {
                if (value == null) return;

                cubit.changeBranch(value);
              },

              selectedItemBuilder: (context) {
                return items.map(
                      (item) {
                    final int itemValue = item.value ?? 0;

                    String text;

                    if (itemValue == 0) {
                      text = AppLanguageKeys.allBranches;
                    } else {
                      final branch = cubit.branches.firstWhere(
                            (branch) =>
                        branch.branchId == itemValue,
                      );

                      text = branch.getBranchName(context);
                    }

                    return Align(
                      alignment:
                      AlignmentDirectional.centerStart,
                      child: TextInAppWidget(
                        text: text,
                        textSize: 14,
                        textColor: AppColors.whiteColor,
                        fontWeightIndex:
                        FontSelectionData
                            .regularFontFamily,
                      ),
                    );
                  },
                ).toList();
              },
            ),
          ),
        );
      },
    );
  }
}