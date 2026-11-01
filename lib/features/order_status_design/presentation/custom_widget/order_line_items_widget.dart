import 'package:flutter/material.dart';
import '../../../internal_services/data/model/get_provider_orders_model/order_line_item.dart';
import '../../../../core/theming/colors.dart';

String orderAmount(num? value) => value == null
    ? '—'
    : value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');

class OrderLineItemsWidget extends StatelessWidget {
  const OrderLineItemsWidget(
      {super.key, required this.items, required this.isArabic});
  final List<OrderLineItem> items;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    String label(String ar, String en) => isArabic ? ar : en;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      for (final kind in OrderLineKind.values)
        if (items.any((item) => item.kind == kind)) ...[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                  switch (kind) {
                    OrderLineKind.service => label('الخدمات', 'Services'),
                    OrderLineKind.product => label('المنتجات', 'Products'),
                    OrderLineKind.package => label('الباقات', 'Packages'),
                  },
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          for (final item in items.where((item) => item.kind == kind))
            Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.displayName(isArabic),
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Wrap(spacing: 16, runSpacing: 6, children: [
                        Text(
                            '${label('الكمية', 'Quantity')}: ${orderAmount(item.quantity)}'),
                        if (item.size?.trim().isNotEmpty == true)
                          Text('${label('المقاس', 'Size')}: ${item.size}'),
                        Text(
                            '${label('سعر الوحدة', 'Unit price')}: ${orderAmount(item.unitPrice)} ${label('ر.س', 'SAR')}'),
                        if (item.taxPercentage != null)
                          Text(
                              '${label('الضريبة', 'Tax')}: ${orderAmount(item.taxPercentage)}%'),
                        Text(
                            '${label('إجمالي البند', 'Line total')}: ${orderAmount(item.totalPrice)} ${label('ر.س', 'SAR')}',
                            style:
                                const TextStyle(color: AppColors.orangeColor)),
                      ]),
                      if (item.contents?.trim().isNotEmpty == true)
                        Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                                '${label('محتويات الباقة', 'Package contents')}: ${item.contents}')),
                    ])),
        ],
    ]);
  }
}
