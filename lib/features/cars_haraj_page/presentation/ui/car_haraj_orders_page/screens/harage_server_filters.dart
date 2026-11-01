import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/app_filter_dialog.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/page_size_filter.dart';
import 'package:sun_web_system/core/setup_git_it.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import '../../../bloc/harag_cubit/harag_cubit.dart';
import '../../../bloc/harag_cubit/harag_state.dart';

class HarageServerFilters extends StatelessWidget {
  const HarageServerFilters({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<HaragCubit, HaragState>(builder: (context, state) {
        final cubit = context.read<HaragCubit>();
        return AppFilterButton(
          key: const Key('harage-filter-button'),
          activeCount: (cubit.includeSuspended ? 1 : 0) +
              (cubit.haragePageSize == 20 ? 0 : 1),
          onPressed: () async {
            final branchId = cubit.selectedHarageBranchId;
            final ar = Localizations.localeOf(context).languageCode == 'ar';
            final branch = getIt<BranchCubit>()
                .branches
                .where((branch) => branch.branchId == branchId)
                .firstOrNull;
            final name = branchId == null
                ? (ar ? 'كل الفروع' : 'All branches')
                : (ar ? branch?.branchName : branch?.branchLatinName) ??
                    '#$branchId';
            var suspended = cubit.includeSuspended;
            var pageSize = cubit.haragePageSize;
            final applied = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => StatefulBuilder(
                    builder: (dialogContext, setDialogState) => AppFilterDialog(
                          title:
                              ar ? 'تصفية إعلانات الحراج' : 'Filter Harage ads',
                          onReset: () => setDialogState(() {
                            suspended = false;
                            pageSize = 20;
                          }),
                          onApply: () => Navigator.pop(dialogContext, true),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InputDecorator(
                                    decoration: InputDecoration(
                                        labelText: ar
                                            ? 'الفرع الحالي'
                                            : 'Current branch',
                                        prefixIcon: const Icon(
                                            Icons.storefront_outlined,
                                            color: AppColors.orangeColor)),
                                    child: Text(name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis)),
                                const SizedBox(height: 18),
                                Material(
                                    color: AppColors.scaffoldColor,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        side: const BorderSide(
                                            color: AppColors.cardStroke)),
                                    child: SwitchListTile.adaptive(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 14, vertical: 6),
                                        activeThumbColor: AppColors.orangeColor,
                                        activeTrackColor: AppColors.orangeColor
                                            .withValues(alpha: .22),
                                        title: Text(
                                            ar
                                                ? 'إظهار الإعلانات الموقوفة'
                                                : 'Include suspended ads',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.darkColor)),
                                        value: suspended,
                                        onChanged: (show) => setDialogState(
                                            () => suspended = show))),
                                const SizedBox(height: 22),
                                PageSizeFilter(
                                    value: pageSize,
                                    onChanged: (size) =>
                                        setDialogState(() => pageSize = size)),
                              ]),
                        )));
            if (!context.mounted ||
                cubit.isClosed ||
                applied != true ||
                branchId != cubit.selectedHarageBranchId) {
              return;
            }
            if (suspended == cubit.includeSuspended &&
                pageSize == cubit.haragePageSize) {
              return;
            }
            await cubit.applyHarageFilters(
                branchId: branchId,
                showSuspended: suspended,
                pageSize: pageSize);
          },
        );
      });
}
