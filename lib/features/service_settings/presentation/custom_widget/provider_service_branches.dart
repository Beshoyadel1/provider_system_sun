import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_state.dart';
import '../../data/model/service_branch.dart';

String _branchName(ServiceBranch branch, bool ar) {
  final preferred = ar ? branch.name : branch.latinName;
  final fallback = ar ? branch.latinName : branch.name;
  return preferred.trim().isNotEmpty
      ? preferred
      : fallback.trim().isNotEmpty
          ? fallback
          : '${ar ? 'فرع' : 'Branch'} #${branch.id}';
}

Map<int, ServiceBranch> _catalog(BranchCubit cubit) => {
      for (final branch in cubit.branches)
        if ((branch.branchId ?? 0) > 0)
          branch.branchId!: ServiceBranch(
            id: branch.branchId!,
            name: branch.branchName ?? '',
            latinName: branch.branchLatinName ?? '',
          ),
    };

class ProviderServiceBranchesField extends StatelessWidget {
  const ProviderServiceBranchesField({
    super.key,
    required this.branchIds,
    required this.onChanged,
    this.availableBranches = const [],
  });

  final List<int> branchIds;
  final ValueChanged<List<int>> onChanged;
  final List<ServiceBranch> availableBranches;

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return BlocBuilder<BranchCubit, BranchState>(builder: (context, state) {
      final cubit = context.read<BranchCubit>();
      final names = {
        ..._catalog(cubit),
        for (final branch in availableBranches) branch.id: branch,
      };
      final selectable = {
        for (final branch in cubit.branches)
          if (branch.isActive == true && (branch.branchId ?? 0) > 0)
            branch.branchId!,
      };
      final visibleIds = {...selectable, ...branchIds};
      return FormField<List<int>>(
        initialValue: branchIds,
        validator: (_) {
          if (state is BranchLoading || state is BranchInitial) {
            return ar ? 'انتظر تحميل الفروع' : 'Wait for branches to load';
          }
          if (state is BranchError) {
            return ar
                ? 'تعذر تحميل الفروع، أعد المحاولة'
                : 'Unable to load branches. Please retry';
          }
          return branchIds.isEmpty
              ? (ar
                  ? 'اختر فرعًا واحدًا على الأقل'
                  : 'Select at least one branch')
              : null;
        },
        builder: (field) => InputDecorator(
          decoration: InputDecoration(
            labelText: ar ? 'الفروع المتاحة' : 'Available branches',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            errorText: field.errorText,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (state is BranchLoading || state is BranchInitial)
              const LinearProgressIndicator(color: AppColors.orangeColor)
            else if (state is BranchError) ...[
              Text(ar ? 'تعذر تحميل الفروع' : 'Unable to load branches'),
              TextButton(
                onPressed: () => cubit.getProviderBranches(),
                child: Text(ar ? 'إعادة المحاولة' : 'Retry'),
              ),
            ] else if (visibleIds.isEmpty)
              Text(ar
                  ? 'لا توجد فروع متاحة. أضف فرعًا أولًا.'
                  : 'No branches available. Add a branch first.')
            else
              Wrap(spacing: 8, runSpacing: 4, children: [
                for (final id in visibleIds)
                  FilterChip(
                    label: Text(
                        _branchName(names[id] ?? ServiceBranch(id: id), ar)),
                    selected: branchIds.contains(id),
                    selectedColor: AppColors.orangeColor.withValues(alpha: .15),
                    checkmarkColor: AppColors.orangeColor,
                    onSelected: (selected) {
                      final ids = branchIds.toSet();
                      selected ? ids.add(id) : ids.remove(id);
                      final updated = ids.toList();
                      field.didChange(updated);
                      onChanged(updated);
                    },
                  ),
              ]),
          ]),
        ),
      );
    });
  }
}

class ProviderServiceBranchFilter extends StatelessWidget {
  const ProviderServiceBranchFilter({
    super.key,
    required this.branchId,
    required this.onChanged,
    this.enabled = true,
  });

  final int? branchId;
  final ValueChanged<int?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return BlocBuilder<BranchCubit, BranchState>(builder: (context, state) {
      final cubit = context.read<BranchCubit>();
      if (state is BranchLoading || state is BranchInitial) {
        return const LinearProgressIndicator(color: AppColors.orangeColor);
      }
      if (state is BranchError) {
        return Row(children: [
          Expanded(
              child: Text(ar
                  ? 'تعذر تحميل فلتر الفروع'
                  : 'Unable to load branch filter')),
          TextButton(
            onPressed: () => cubit.getProviderBranches(),
            child: Text(ar ? 'إعادة المحاولة' : 'Retry'),
          ),
        ]);
      }
      final branches = _catalog(cubit);
      if (branchId != null && !branches.containsKey(branchId)) {
        branches[branchId!] = ServiceBranch(id: branchId!);
      }
      return DropdownButtonFormField<int>(
        key: ValueKey('service-branch-filter-$branchId'),
        initialValue: branchId ?? 0,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: ar ? 'فلترة حسب الفرع' : 'Filter by branch',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: [
          DropdownMenuItem(
              value: 0, child: Text(ar ? 'كل الفروع' : 'All branches')),
          for (final branch in branches.values)
            DropdownMenuItem(
                value: branch.id, child: Text(_branchName(branch, ar))),
        ],
        onChanged:
            enabled ? (value) => onChanged(value == 0 ? null : value) : null,
      );
    });
  }
}

class ProviderServiceBranchesSummary extends StatelessWidget {
  const ProviderServiceBranchesSummary({
    super.key,
    required this.branchIds,
    this.availableBranches = const [],
  });

  final List<int> branchIds;
  final List<ServiceBranch> availableBranches;

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return BlocBuilder<BranchCubit, BranchState>(builder: (context, state) {
      final names = {
        ..._catalog(context.read<BranchCubit>()),
        for (final branch in availableBranches) branch.id: branch,
      };
      final label = branchIds.isEmpty
          ? (ar ? 'لم تُحدد فروع' : 'No branches assigned')
          : branchIds
              .toSet()
              .map((id) => _branchName(names[id] ?? ServiceBranch(id: id), ar))
              .join('، ');
      return Tooltip(
        message: label,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.location_on_outlined,
              size: 18, color: AppColors.orangeColor),
          const SizedBox(width: 4),
          Expanded(
              child: Text(label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12))),
        ]),
      );
    });
  }
}
