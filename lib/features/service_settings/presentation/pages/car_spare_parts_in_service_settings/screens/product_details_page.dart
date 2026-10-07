import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'package:sun_web_system/features/service_settings/data/repository/products_repository.dart';
import 'product_inventory_view.dart';
import '../sub/add_spare_parts_in_service_settings/add_spare_parts_in_service_settings.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId;
  final ProductsRepository repository;
  final ProductsWriter writer;
  final Widget Function(ProductModelGetProductsByCategory)? editPageBuilder;
  const ProductDetailsPage({
    super.key,
    required this.productId,
    this.repository = const NetworkProductsRepository(),
    this.writer = const NetworkProductsRepository(),
    this.editPageBuilder,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<ProductModelGetProductsByCategory> _details;
  bool _busy = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _details = widget.repository.getProduct(widget.productId);
  }

  void _reload() => setState(() {
        _details = widget.repository.getProduct(widget.productId);
      });

  Future<void> _edit(ProductModelGetProductsByCategory product) async {
    setState(() => _busy = true);
    final saved = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
            builder: (_) =>
                widget.editPageBuilder?.call(product) ??
                AddSparePartsInServiceSettings(product: product)));
    if (!mounted) return;
    setState(() => _busy = false);
    if (saved == true) _reload();
  }

  Future<void> _delete(bool ar) async {
    setState(() => _busy = true);
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: Text(ar ? 'حذف المنتج' : 'Delete product'),
              content:
                  Text(ar ? 'هل تريد حذف هذا المنتج؟' : 'Delete this product?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(ar ? 'إلغاء' : 'Cancel')),
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(ar ? 'حذف' : 'Delete')),
              ],
            ));
    if (!mounted) return;
    if (confirmed != true) {
      setState(() => _busy = false);
      return;
    }
    setState(() => _deleting = true);
    try {
      await widget.writer.deleteProduct(widget.productId);
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _deleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: Text(ar ? 'تفاصيل المنتج' : 'Product details'),
        actions: [
          IconButton(
            onPressed: _busy ? null : _reload,
            tooltip: ar ? 'تحديث' : 'Refresh',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<ProductModelGetProductsByCategory>(
          future: _details,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(snapshot.error?.toString() ??
                          (ar
                              ? 'تعذر تحميل المنتج'
                              : 'Unable to load product')),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _reload,
                        child: Text(ar ? 'إعادة المحاولة' : 'Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            final product = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(spacing: 12, runSpacing: 8, children: [
                    FilledButton.icon(
                        onPressed: _busy ? null : () => _edit(product),
                        icon: const Icon(Icons.edit),
                        label: Text(ar ? 'تعديل' : 'Edit')),
                    OutlinedButton.icon(
                        onPressed: _busy ? null : () => _delete(ar),
                        icon: const Icon(Icons.delete),
                        label: Text(ar ? 'حذف' : 'Delete')),
                    if (_deleting) const CircularProgressIndicator(),
                  ]),
                  const SizedBox(height: 12),
                  Card(
                    color: AppColors.whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.image?.isNotEmpty == true)
                            Center(
                              child: Image.memory(
                                product.image!,
                                height: 140,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 80),
                              ),
                            ),
                          Text(product.getName(context),
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          Wrap(spacing: 20, runSpacing: 8, children: [
                            Text(
                                '${ar ? 'رقم المنتج' : 'Product ID'}: ${product.id}'),
                            Text(
                                '${ar ? 'السعر' : 'Price'}: ${product.price ?? 0}'),
                            Text(
                                '${ar ? 'التكلفة' : 'Cost'}: ${product.cost ?? 0}'),
                            if (product.category != null)
                              Text(product.category!.getName(context)),
                          ]),
                          if (product.getDescription(context).isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(product.getDescription(context)),
                          ],
                          if (product.instructions?.isNotEmpty == true) ...[
                            const SizedBox(height: 12),
                            Text(
                                '${ar ? 'التعليمات' : 'Instructions'}: ${product.instructions}'),
                          ],
                          if (product.brands.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Wrap(spacing: 8, runSpacing: 8, children: [
                              for (final brand in product.brands)
                                Chip(
                                    label: Text([
                                  brand.getBrandName(context),
                                  ...brand.models
                                      .map((model) => model.modelName ?? ''),
                                ]
                                        .where((name) => name.isNotEmpty)
                                        .join(' / '))),
                            ]),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ProductInventoryView(product: product),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
