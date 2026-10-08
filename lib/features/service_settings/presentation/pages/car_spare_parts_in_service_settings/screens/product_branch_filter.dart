import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/presentation/custom_widget/branch_filter_dropdown.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_state.dart';

class ProductBranchFilter extends StatelessWidget {
  const ProductBranchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return BlocBuilder<BranchCubit, BranchState>(builder: (context, state) {
      final cubit = context.read<BranchCubit>();
      if (state is BranchLoading || state is BranchInitial) {
        return const LinearProgressIndicator(color: AppColors.orangeColor);
      }
      if (state is BranchError) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ar ? 'تعذر تحميل فلتر الفروع' : 'Unable to load branch filter'),
          Text(state.message),
          TextButton(
            onPressed: cubit.getProviderBranches,
            child: Text(ar ? 'إعادة المحاولة' : 'Retry'),
          ),
        ]);
      }
      final branches = {
        for (final branch in cubit.branches)
          if (branch.isActive == true && (branch.branchId ?? 0) > 0)
            branch.branchId!: branch,
      };
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BranchFilterDropdown(
          key: ValueKey('product-branch-${cubit.selectedBranchId}'),
          value: cubit.selectedBranchId,
          label: ar ? 'الفرع' : 'Branch',
          items: {
            0: ar ? 'كل الفروع' : 'All branches',
            for (final entry in branches.entries)
              entry.key: entry.value.getBranchName(context),
          },
          onChanged: (value) {
            if (value != null) cubit.changeBranch(value);
          },
        ),
        const SizedBox(height: 8),
        TextInAppWidget(
          text: ar
              ? 'اختيار الفرع يفلتر المنتجات المتاحة فيه. تفاصيل مخزون الفروع داخل المنتج.'
              : 'The branch filter shows available products. Open a product for branch stock details.',
          textSize: 11,
          textColor: AppColors.darkGreyColor,
          fontWeightIndex: FontSelectionData.regularFontFamily,
        ),
      ]);
    });
  }
}
