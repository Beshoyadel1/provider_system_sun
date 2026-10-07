import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';

class ProductInventoryView extends StatelessWidget {
  final ProductModelGetProductsByCategory product;
  const ProductInventoryView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InventorySection(
          title: ar ? 'إجمالي المخزون' : 'Total stock',
          child: Text('${product.displayStock}',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        if (product.sizes.isEmpty && product.generalBranchStocks.isNotEmpty)
          _InventorySection(
            title: ar ? 'مخزون المنتج بدون مقاس' : 'Stock without a size',
            child: ProductBranchStockTable(stocks: product.generalBranchStocks),
          ),
        if (product.sizes.isNotEmpty)
          _InventorySection(
            title: ar ? 'المقاسات ومخزون الفروع' : 'Sizes and branch stock',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: product.sizes.map((size) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (ar ? size.name : size.latinName) ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 20,
                        runSpacing: 8,
                        children: [
                          Text('${ar ? 'السعر' : 'Price'}: ${size.price ?? 0}'),
                          Text('${ar ? 'التكلفة' : 'Cost'}: ${size.cost ?? 0}'),
                          Text(
                              '${ar ? 'إجمالي المقاس' : 'Size total'}: ${size.inStock ?? '—'}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (size.branchStocks.isNotEmpty)
                        ProductBranchStockTable(stocks: size.branchStocks)
                      else
                        Text(ar
                            ? 'لا توجد بيانات مخزون للفروع'
                            : 'No branch stock data'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class ProductBranchStockTable extends StatelessWidget {
  final List<ProductBranchStock> stocks;
  const ProductBranchStockTable({super.key, required this.stocks});

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        horizontalMargin: 8,
        columns: [
          DataColumn(label: Text(ar ? 'الفرع' : 'Branch')),
          DataColumn(label: Text(ar ? 'الكمية' : 'Quantity'), numeric: true),
          DataColumn(label: Text(ar ? 'الحالة' : 'Status')),
        ],
        rows: stocks
            .map((stock) => DataRow(cells: [
                  DataCell(Text(stock.getBranchName(ar))),
                  DataCell(Text('${stock.inStock}')),
                  DataCell(Text(
                    stock.isActive
                        ? (ar ? 'مفعّل' : 'Active')
                        : (ar ? 'غير مفعّل' : 'Inactive'),
                    style: TextStyle(
                      color:
                          stock.isActive ? Colors.green.shade700 : Colors.grey,
                    ),
                  )),
                ]))
            .toList(),
      ),
    );
  }
}

class _InventorySection extends StatelessWidget {
  final String title;
  final Widget child;
  const _InventorySection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.whiteColor,
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      );
}
