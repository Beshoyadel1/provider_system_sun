import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
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
        return const LinearProgressIndicator();
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
        DropdownButtonFormField<int>(
          key: ValueKey('product-branch-${cubit.selectedBranchId}'),
          initialValue: branches.containsKey(cubit.selectedBranchId)
              ? cubit.selectedBranchId
              : 0,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: ar ? 'الفرع' : 'Branch',
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
                value: 0, child: Text(ar ? 'كل الفروع' : 'All branches')),
            for (final entry in branches.entries)
              DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value.getBranchName(context))),
          ],
          onChanged: (value) {
            if (value != null) cubit.changeBranch(value);
          },
        ),
        const SizedBox(height: 8),
        Text(ar
            ? 'اختيار الفرع يفلتر المنتجات المتاحة فيه. تفاصيل مخزون الفروع داخل المنتج.'
            : 'The branch filter shows available products. Open a product for branch stock details.'),
      ]);
    });
  }
}
