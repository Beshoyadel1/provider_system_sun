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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BlocBuilder<BranchCubit, BranchState>(
      bloc: getIt<BranchCubit>(),
      builder: (context, state) {
        final cubit = getIt<BranchCubit>();
        final branches = cubit.branches
            .where(
              (branch) =>
                  branch.isActive == true &&
                  branch.branchId != null &&
                  branch.branchId != 0,
            )
            .toList();

        final selectedExists = selectedBranchId == 0 ||
            branches.any((branch) => branch.branchId == selectedBranchId);
        final selectedValue = selectedExists ? selectedBranchId : null;
        final matchingBranches = branches
            .where((branch) => branch.branchId == selectedBranchId)
            .toList();
        final selectedBranchName = selectedBranchId == 0
            ? AppLanguageKeys.allBranches
            : matchingBranches.isEmpty
                ? null
                : matchingBranches.first.getBranchName(context);

        return SizedBox(
          width: isMobile ? double.infinity : (width ?? 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: TextInAppWidget(
                  text: AppLanguageKeys.branchesKey,
                  textSize: 14,
                ),
              ),
              Container(
                height: height,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: fillColor ?? AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor ?? AppColors.lightGreyColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkColor.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 19,
                      color: AppColors.orangeColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: state is BranchLoading && branches.isEmpty
                          ? const Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.orangeColor,
                                ),
                              ),
                            )
                          : readOnly
                              ? Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: TextInAppWidget(
                                    text: selectedBranchName ??
                                        AppLanguageKeys.allBranches,
                                    textSize: 14,
                                    textColor: AppColors.blackColor,
                                    fontWeightIndex:
                                        FontSelectionData.regularFontFamily,
                                  ),
                                )
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: selectedValue,
                                    isExpanded: true,
                                    hint: const TextInAppWidget(
                                      text: AppLanguageKeys.allBranches,
                                      textSize: 14,
                                      textColor: AppColors.darkGreyColor,
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                      color: AppColors.orangeColor,
                                    ),
                                    items: [
                                      const DropdownMenuItem<int>(
                                        value: 0,
                                        child: TextInAppWidget(
                                          text: AppLanguageKeys.allBranches,
                                          textSize: 14,
                                          textColor: AppColors.blackColor,
                                        ),
                                      ),
                                      ...branches.map(
                                        (branch) => DropdownMenuItem<int>(
                                          value: branch.branchId,
                                          child: TextInAppWidget(
                                            text: branch.getBranchName(context),
                                            textSize: 14,
                                            textColor: AppColors.blackColor,
                                            fontWeightIndex: FontSelectionData
                                                .regularFontFamily,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: state is BranchLoading
                                        ? null
                                        : onChanged,
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
              if (state is BranchError && branches.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      color: AppColors.redColor,
                      fontSize: 12,
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
