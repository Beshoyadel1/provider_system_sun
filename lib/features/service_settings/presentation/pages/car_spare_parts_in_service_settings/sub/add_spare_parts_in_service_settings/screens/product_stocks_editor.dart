import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_state.dart';
import 'product_stock_controller.dart';

class ProductStocksEditor extends StatefulWidget {
  final List<ProductStockController> stocks;
  const ProductStocksEditor({super.key, required this.stocks});

  @override
  State<ProductStocksEditor> createState() => _ProductStocksEditorState();
}

class _ProductStocksEditorState extends State<ProductStocksEditor> {
  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return Material(
        type: MaterialType.transparency,
        child: BlocBuilder<BranchCubit, BranchState>(builder: (context, state) {
          final cubit = context.read<BranchCubit>();
          final branches = {
            for (final branch in cubit.branches)
              if ((branch.branchId ?? 0) > 0) branch.branchId!: branch,
          };
          final available = branches.values
              .where((branch) =>
                  branch.isActive == true &&
                  !widget.stocks.any((row) => row.branchId == branch.branchId))
              .toList();
          return FormField<List<ProductStockController>>(
            validator: (_) {
              if (widget.stocks.isEmpty) {
                return ar
                    ? 'أضف فرعًا واحدًا على الأقل للمخزون'
                    : 'Add at least one stock branch';
              }
              final ids = widget.stocks.map((row) => row.branchId).toList();
              return ids.any((id) => id <= 0) ||
                      ids.toSet().length != ids.length
                  ? (ar ? 'راجع الفروع المختارة' : 'Check selected branches')
                  : null;
            },
            builder: (field) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(ar ? 'مخزون الفروع' : 'Branch stock'),
                if (state is BranchLoading || state is BranchInitial)
                  const LinearProgressIndicator(),
                if (state is BranchError) ...[
                  Text(state.message),
                  TextButton(
                      onPressed: cubit.getProviderBranches,
                      child:
                          Text(ar ? 'إعادة تحميل الفروع' : 'Retry branches')),
                ],
                if (state is BranchSuccess && branches.isEmpty)
                  Text(ar
                      ? 'لا توجد فروع. أضف فرعًا أولًا.'
                      : 'No branches. Add a branch first.'),
                for (final row in widget.stocks)
                  Padding(
                    key: ObjectKey(row),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(children: [
                            Expanded(
                                child: Text(
                              branches[row.branchId]?.getBranchName(context) ??
                                  (ar ? row.branchName : row.branchLatinName) ??
                                  '${ar ? 'فرع' : 'Branch'} #${row.branchId}',
                              overflow: TextOverflow.ellipsis,
                            )),
                            IconButton(
                                tooltip: ar
                                    ? 'حذف الفرع من المخزون'
                                    : 'Remove stock branch',
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() => widget.stocks.remove(row));
                                  row.dispose();
                                  field.didChange(widget.stocks);
                                }),
                          ]),
                          TextFormField(
                            controller: row.quantity,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                labelText: ar ? 'الكمية' : 'Quantity',
                                border: const OutlineInputBorder()),
                            validator: (value) {
                              final quantity =
                                  int.tryParse(value?.trim() ?? '');
                              return quantity == null || quantity < 0
                                  ? (ar
                                      ? 'أدخل كمية صحيحة لا تقل عن صفر'
                                      : 'Enter a non-negative whole quantity')
                                  : null;
                            },
                          ),
                          SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                  ar ? 'متاح في الفرع' : 'Active at branch'),
                              value: row.isActive,
                              onChanged: (value) =>
                                  setState(() => row.isActive = value)),
                        ]),
                  ),
                if (available.isNotEmpty)
                  DropdownButtonFormField<int>(
                    key: ValueKey(
                        available.map((branch) => branch.branchId).join(',')),
                    isExpanded: true,
                    decoration: InputDecoration(
                        labelText:
                            ar ? 'إضافة فرع للمخزون' : 'Add stock branch',
                        border: const OutlineInputBorder()),
                    items: available
                        .map((branch) => DropdownMenuItem(
                            value: branch.branchId,
                            child: Text(branch.getBranchName(context))))
                        .toList(),
                    onChanged: (id) {
                      if (id == null) return;
                      final branch = branches[id]!;
                      setState(() => widget.stocks.add(ProductStockController(
                          branchId: id,
                          branchName: branch.branchName,
                          branchLatinName: branch.branchLatinName)));
                      field.didChange(widget.stocks);
                    },
                  ),
                if (field.hasError)
                  Text(field.errorText!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
              ],
            ),
          );
        }));
  }
}
