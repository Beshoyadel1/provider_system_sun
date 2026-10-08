import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import 'package:sun_web_system/features/store_page/presentation/bloc/branch_cubit/branch_state.dart';
import 'product_form_widgets.dart';
import 'product_stock_controller.dart';

class ProductStocksEditor extends StatefulWidget {
  const ProductStocksEditor({super.key, required this.stocks});
  final List<ProductStockController> stocks;
  @override
  State<ProductStocksEditor> createState() => _ProductStocksEditorState();
}

class _ProductStocksEditorState extends State<ProductStocksEditor> {
  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return BlocBuilder<BranchCubit, BranchState>(builder: (context, state) {
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
          return ids.any((id) => id <= 0) || ids.toSet().length != ids.length
              ? (ar ? 'راجع الفروع المختارة' : 'Check selected branches')
              : null;
        },
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state is BranchLoading || state is BranchInitial)
              const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: LinearProgressIndicator(color: AppColors.orangeColor)),
            if (state is BranchError)
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.orangeColor),
                onPressed: cubit.getProviderBranches,
                child: TextInAppWidget(
                    text: ar
                        ? 'تعذر تحميل الفروع، أعد المحاولة'
                        : 'Unable to load branches. Retry',
                    textSize: 12,
                    textColor: AppColors.orangeColor),
              ),
            if (state is BranchSuccess && branches.isEmpty)
              TextInAppWidget(
                  text: ar
                      ? 'لا توجد فروع. أضف فرعًا أولًا.'
                      : 'No branches. Add a branch first.',
                  textSize: 12,
                  textColor: AppColors.darkGreyColor),
            if (widget.stocks.isNotEmpty) ...[
              ProductFieldLabel(
                label: ar ? 'مخزون الفروع' : 'Branch stock',
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      for (final row in widget.stocks)
                        Container(
                          key: ObjectKey(row),
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldColor,
                            border: Border.all(color: AppColors.cardStroke),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(children: [
                            Row(children: [
                              Expanded(
                                  child: TextInAppWidget(
                                      text: branches[row.branchId]
                                              ?.getBranchName(context) ??
                                          (ar
                                              ? row.branchName
                                              : row.branchLatinName) ??
                                          '${ar ? 'فرع' : 'Branch'} #${row.branchId}',
                                      textSize: 12,
                                      textColor: AppColors.darkColor,
                                      maxLines: 1,
                                      isEllipsisTextOverflow: true)),
                              Tooltip(
                                message:
                                    ar ? 'متاح في الفرع' : 'Active at branch',
                                child: Switch(
                                  value: row.isActive,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  activeThumbColor: AppColors.orangeColor,
                                  activeTrackColor: AppColors.orangeColor
                                      .withValues(alpha: 0.25),
                                  inactiveThumbColor: AppColors.darkGreyColor,
                                  inactiveTrackColor:
                                      AppColors.veryLightGreyColor,
                                  trackOutlineColor:
                                      const WidgetStatePropertyAll(
                                          AppColors.transparent),
                                  onChanged: (value) =>
                                      setState(() => row.isActive = value),
                                ),
                              ),
                              IconButton(
                                tooltip: ar
                                    ? 'حذف الفرع من المخزون'
                                    : 'Remove stock branch',
                                constraints: const BoxConstraints(
                                    minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.delete_outline,
                                    size: 20, color: AppColors.redColor),
                                onPressed: () {
                                  setState(() => widget.stocks.remove(row));
                                  row.dispose();
                                  field.didChange(widget.stocks);
                                },
                              ),
                            ]),
                            ProductFieldLabel(
                              label: ar ? 'الكمية' : 'Quantity',
                              child: TextFormField(
                                controller: row.quantity,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: ProductFormStyle.textStyle,
                                cursorColor: AppColors.orangeColor,
                                decoration:
                                    ProductFormStyle.decoration(context),
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
                            ),
                          ]),
                        ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (available.isNotEmpty)
              ProductDropdownField<int>(
                key: ValueKey(
                    available.map((branch) => branch.branchId).join(',')),
                label: ar ? 'إضافة فرع للمخزون' : 'Add stock branch',
                value: null,
                items: [
                  for (final branch in available)
                    DropdownMenuItem(
                        value: branch.branchId,
                        child: TextInAppWidget(
                            text: branch.getBranchName(context),
                            textSize: 13,
                            textColor: AppColors.darkColor,
                            maxLines: 1,
                            isEllipsisTextOverflow: true))
                ],
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
              Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: TextInAppWidget(
                      text: field.errorText!,
                      textSize: 11,
                      textColor: AppColors.redColor)),
          ],
        ),
      );
    });
  }
}
