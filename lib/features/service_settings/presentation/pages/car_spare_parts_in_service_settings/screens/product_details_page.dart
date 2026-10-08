import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_cubit/language_cubit.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_products_by_category_model/product_model_get_products_by_category.dart';
import 'package:sun_web_system/features/service_settings/data/repository/products_repository.dart';
import 'product_inventory_view.dart';
import 'product_details_summary.dart';
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
              backgroundColor: AppColors.whiteColor,
              surfaceTintColor: AppColors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: TextInAppWidget(
                text: ar ? 'حذف المنتج' : 'Delete product',
                textSize: 20,
                textColor: AppColors.redColor,
                fontWeightIndex: FontSelectionData.semiBoldFontFamily,
                isTextCenter: true,
              ),
              content: TextInAppWidget(
                text: ar ? 'هل تريد حذف هذا المنتج؟' : 'Delete this product?',
                textSize: 15,
                textColor: AppColors.darkColor,
                isTextCenter: true,
              ),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.darkGreyColor,
                    ),
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: TextInAppWidget(
                      text: ar ? 'إلغاء' : 'Cancel',
                      textSize: 14,
                      textColor: AppColors.darkGreyColor,
                    )),
                FilledButton(
                    style: _actionStyle(AppColors.redColor),
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: TextInAppWidget(
                      text: ar ? 'حذف' : 'Delete',
                      textSize: 14,
                      textColor: AppColors.whiteColor,
                    )),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.redColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: TextInAppWidget(
            text: error.toString(),
            textSize: 14,
            textColor: AppColors.whiteColor,
          ),
        ));
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

  ButtonStyle _actionStyle(Color color) => FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.whiteColor,
        disabledBackgroundColor: AppColors.lightGreyColor,
        disabledForegroundColor: AppColors.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ar = LanguageCubit.get(context).isAllAppLanguageArabic;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        foregroundColor: AppColors.darkColor,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        title: TextInAppWidget(
          text: ar ? 'تفاصيل المنتج' : 'Product details',
          textSize: 18,
          textColor: AppColors.darkColor,
          fontWeightIndex: FontSelectionData.semiBoldFontFamily,
        ),
        actions: [
          IconButton(
            onPressed: _busy ? null : _reload,
            tooltip: ar ? 'تحديث' : 'Refresh',
            color: AppColors.orangeColor,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<ProductModelGetProductsByCategory>(
          future: _details,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.orangeColor),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextInAppWidget(
                        text: snapshot.error?.toString() ??
                            (ar
                                ? 'تعذر تحميل المنتج'
                                : 'Unable to load product'),
                        textSize: 14,
                        textColor: AppColors.darkGreyColor,
                        isTextCenter: true,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.orangeColor,
                          side: const BorderSide(color: AppColors.orangeColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _reload,
                        child: TextInAppWidget(
                          text: ar ? 'إعادة المحاولة' : 'Retry',
                          textSize: 14,
                          textColor: AppColors.orangeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            final product = snapshot.data!;
            return LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 600 ? 12 : 20,
                  vertical: 16,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ProductDetailsSummary(product: product),
                        const SizedBox(height: 12),
                        ProductInventoryView(product: product),
                        const SizedBox(height: 16),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Wrap(
                            key: const ValueKey('product-details-actions'),
                            spacing: 12,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              FilledButton.icon(
                                  style: _actionStyle(AppColors.blackColor44),
                                  onPressed:
                                      _busy ? null : () => _edit(product),
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: TextInAppWidget(
                                    text: ar ? 'تعديل' : 'Edit',
                                    textSize: 14,
                                    textColor: AppColors.whiteColor,
                                  )),
                              FilledButton.icon(
                                  style: _actionStyle(AppColors.redColor),
                                  onPressed: _busy ? null : () => _delete(ar),
                                  icon: const Icon(Icons.delete_outline,
                                      size: 18),
                                  label: TextInAppWidget(
                                    text: ar ? 'حذف' : 'Delete',
                                    textSize: 14,
                                    textColor: AppColors.whiteColor,
                                  )),
                              if (_deleting)
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.orangeColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
