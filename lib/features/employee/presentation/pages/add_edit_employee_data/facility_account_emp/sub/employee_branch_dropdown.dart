import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/setup_git_it.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_state.dart';

class EmployeeBranchDropdown extends StatelessWidget {
  const EmployeeBranchDropdown({
    super.key,
    required this.selectedBranchId,
    required this.readOnly,
    required this.onChanged,
    this.width,
    this.height = 40,
    this.borderColor,
    this.fillColor,
  });

  final int? selectedBranchId;
  final bool readOnly;
  final ValueChanged<int?>? onChanged;

  final double? width;
  final double height;

  final Color? borderColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final bool isMobile =
        MediaQuery.of(context).size.width < 600;

    return BlocBuilder<BranchCubit, BranchState>(
      bloc: getIt<BranchCubit>(),
      builder: (context, state) {
        final cubit = getIt<BranchCubit>();

        final branches = cubit.branches
            .where(
              (branch) =>
          branch.branchId != null &&
              branch.branchId != 0,
        )
            .toList();

        final bool selectedExists = branches.any(
              (branch) =>
          branch.branchId == selectedBranchId,
        );

        final String? selectedBranchName =
        selectedExists
            ? branches
            .firstWhere(
              (branch) =>
          branch.branchId ==
              selectedBranchId,
        )
            .getBranchName(context)
            : null;

        return SizedBox(
          width: isMobile
              ? double.infinity
              : (width ?? 500),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: TextInAppWidget(
                  text: AppLanguageKeys.allBranches,
                  textSize: 14,
                ),
              ),
              Container(
                height: height,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color:
                  fillColor ??
                      AppColors.whiteColor,
                  borderRadius:
                  BorderRadius.circular(10),
                  border: Border.all(
                    color:
                    borderColor ??
                        AppColors.darkGreyColor,
                  ),
                ),
                child: readOnly
                    ? Align(
                  alignment:
                  AlignmentDirectional
                      .centerStart,
                  child: TextInAppWidget(
                    text:
                    selectedBranchName ??
                        AppLanguageKeys.allBranches,
                    textSize: 14,
                    textColor:
                    AppColors.blackColor,
                    fontWeightIndex:
                    FontSelectionData
                        .regularFontFamily,
                  ),
                )
                    : DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedExists
                        ? selectedBranchId
                        : null,
                    isExpanded: true,
                    hint:
                    const TextInAppWidget(
                      text:
                      AppLanguageKeys
                          .allBranches,
                      textSize: 14,
                      textColor:
                      AppColors
                          .darkGreyColor,
                    ),
                    icon: const Icon(
                      Icons
                          .keyboard_arrow_down_rounded,
                      size: 20,
                      color:
                      AppColors
                          .darkGreyColor,
                    ),
                    items: [
                      const DropdownMenuItem<int>(
                        value: 0,
                        child:
                        TextInAppWidget(
                          text:
                          AppLanguageKeys
                              .allBranches,
                          textSize: 14,
                          textColor:
                          AppColors
                              .blackColor,
                        ),
                      ),
                      ...branches.map(
                            (branch) {
                          return DropdownMenuItem<int>(
                            value:
                            branch.branchId,
                            child:
                            TextInAppWidget(
                              text: branch
                                  .getBranchName(
                                context,
                              ),
                              textSize: 14,
                              textColor:
                              AppColors
                                  .blackColor,
                              fontWeightIndex:
                              FontSelectionData
                                  .regularFontFamily,
                            ),
                          );
                        },
                      ),
                    ],
                    onChanged: readOnly
                        ? null
                        : onChanged,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}