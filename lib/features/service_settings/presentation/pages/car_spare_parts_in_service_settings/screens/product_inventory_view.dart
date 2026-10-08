import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';

class ProductInventoryView extends StatelessWidget {
  final ProductModelGetProductsByCategory product;
  const ProductInventoryView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    final hasSizes = product.sizes.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(builder: (context, constraints) {
            final title = TextInAppWidget(
              text: hasSizes
                  ? (ar ? 'المقاسات ومخزون الفروع' : 'Sizes and branch stock')
                  : (ar ? 'مخزون الفروع' : 'Branch stock'),
              textSize: 15,
              textColor: AppColors.darkColor,
              fontWeightIndex: FontSelectionData.semiBoldFontFamily,
            );
            final total = _QuantityBadge(
              key: const ValueKey('product-total-stock'),
              label: ar ? 'إجمالي الكمية' : 'Total quantity',
              quantity: '${product.displayStock}',
            );
            if (constraints.maxWidth < 480) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title, const SizedBox(height: 10), total],
              );
            }
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 16),
                  Flexible(child: total),
                ]);
          }),
          const SizedBox(height: 16),
          if (hasSizes)
            LayoutBuilder(builder: (context, constraints) {
              const gap = 12.0;
              const minCardWidth = 280.0;
              const maxCardWidth = 360.0;
              final available = constraints.maxWidth;
              final maxColumns = math.max(
                  1, ((available + gap) / (minCardWidth + gap)).floor());
              final columns = math.min(
                  maxColumns,
                  math.max(
                      1, ((available + gap) / (maxCardWidth + gap)).ceil()));
              final cardWidth = math.min(
                  maxCardWidth, (available - (columns - 1) * gap) / columns);
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var index = 0; index < product.sizes.length; index++)
                    SizedBox(
                      key: ValueKey('product-size-$index'),
                      width: cardWidth,
                      child: _SizeStockCard(size: product.sizes[index]),
                    ),
                ],
              );
            })
          else if (product.generalBranchStocks.isNotEmpty)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: ProductBranchStockTable(
                    stocks: product.generalBranchStocks),
              ),
            )
          else
            _emptyStock(ar),
        ],
      ),
    );
  }
}

class _SizeStockCard extends StatelessWidget {
  final ProductSizeModel size;
  const _SizeStockCard({required this.size});

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        border: Border.all(color: AppColors.cardStroke),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              flex: 3,
              child: TextInAppWidget(
                text: (ar ? size.name : size.latinName) ?? '',
                textSize: 14,
                textColor: AppColors.darkColor,
                fontWeightIndex: FontSelectionData.semiBoldFontFamily,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 2,
              child: _QuantityBadge(
                label: ar ? 'الكمية' : 'Quantity',
                quantity: '${size.inStock ?? '—'}',
                compact: true,
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Wrap(spacing: 16, runSpacing: 6, children: [
            TextInAppWidget(
              text: '${ar ? 'السعر' : 'Price'}: ${size.price ?? 0}',
              textSize: 13,
              textColor: AppColors.blueColor,
            ),
            TextInAppWidget(
              text: '${ar ? 'التكلفة' : 'Cost'}: ${size.cost ?? 0}',
              textSize: 13,
              textColor: AppColors.blueColor,
            ),
          ]),
          const SizedBox(height: 12),
          if (size.branchStocks.isNotEmpty)
            ProductBranchStockTable(stocks: size.branchStocks)
          else
            _emptyStock(ar),
        ],
      ),
    );
  }
}

class _QuantityBadge extends StatelessWidget {
  final String label;
  final String quantity;
  final bool compact;
  const _QuantityBadge({
    super.key,
    required this.label,
    required this.quantity,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 12, vertical: compact ? 5 : 8),
        decoration: BoxDecoration(
          color: AppColors.blueColor100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TextInAppWidget(
              text: label,
              textSize: compact ? 11 : 12,
              textColor: AppColors.darkGreyColor,
            ),
            TextInAppWidget(
              text: quantity,
              textSize: compact ? 15 : 20,
              textColor: AppColors.blueColor,
              fontWeightIndex: FontSelectionData.semiBoldFontFamily,
            ),
          ],
        ),
      );
}

Widget _emptyStock(bool ar) => TextInAppWidget(
      text: ar ? 'لا توجد بيانات مخزون للفروع' : 'No branch stock data',
      textSize: 13,
      textColor: AppColors.darkGreyColor,
    );

class ProductBranchStockTable extends StatelessWidget {
  final List<ProductBranchStock> stocks;
  const ProductBranchStockTable({super.key, required this.stocks});

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.cardStroke),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: AppColors.greyColor200,
              child: _StockTableRow(
                branch: ar ? 'الفرع' : 'Branch',
                quantity: ar ? 'الكمية' : 'Quantity',
                status: ar ? 'الحالة' : 'Status',
                heading: true,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: SingleChildScrollView(
                primary: false,
                child: Column(children: [
                  for (final stock in stocks)
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.cardStroke),
                        ),
                      ),
                      child: _StockTableRow(
                        branch: stock.getBranchName(ar),
                        quantity: '${stock.inStock}',
                        status: stock.isActive
                            ? (ar ? 'مفعّل' : 'Active')
                            : (ar ? 'غير مفعّل' : 'Inactive'),
                        active: stock.isActive,
                      ),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockTableRow extends StatelessWidget {
  final String branch;
  final String quantity;
  final String status;
  final bool heading;
  final bool active;
  const _StockTableRow({
    required this.branch,
    required this.quantity,
    required this.status,
    this.heading = false,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _cell(branch,
                  heading ? AppColors.darkGreyColor : AppColors.darkColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: _cell(quantity,
                  heading ? AppColors.darkGreyColor : AppColors.blueColor,
                  center: true),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: _cell(
                status,
                !heading && active
                    ? AppColors.greenColor
                    : AppColors.darkGreyColor,
                center: true,
              ),
            ),
          ],
        ),
      );

  Widget _cell(String text, Color color, {bool center = false}) =>
      TextInAppWidget(
        text: text,
        textSize: 12,
        textColor: color,
        isTextCenter: center,
        fontWeightIndex: heading
            ? FontSelectionData.semiBoldFontFamily
            : FontSelectionData.regularFontFamily,
      );
}
