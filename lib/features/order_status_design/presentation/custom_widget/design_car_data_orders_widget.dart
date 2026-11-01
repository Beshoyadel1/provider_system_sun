import 'package:flutter/material.dart';
import '../../../internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import '../../../internal_services/data/model/get_provider_orders_model/order_line_item.dart';
import '../../../../core/theming/colors.dart';
import 'order_line_items_widget.dart';

class DesignCarDataOrdersWidget extends StatelessWidget {
  const DesignCarDataOrdersWidget(
      {super.key,
      this.brandName,
      this.totalPriceCar,
      this.plateNo,
      this.provServices,
      this.products = const [],
      this.packages = const [],
      required this.isArabic});
  final String? brandName, totalPriceCar, plateNo;
  final List<ProvService>? provServices;
  final List<OrderLineItem> products, packages;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final items = [
      for (final service in provServices ?? <ProvService>[])
        OrderLineItem.fromJson(service.toJson(), OrderLineKind.service),
      ...products,
      ...packages,
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.orangeColor.withValues(alpha: 0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 16,
            runSpacing: 8,
            children: [
              Wrap(spacing: 10, children: [
                const Icon(Icons.directions_car, color: AppColors.orangeColor),
                Text(brandName ?? ''),
                Text(plateNo ?? '')
              ]),
              Text(
                  '${isArabic ? 'إجمالي السيارة' : 'Vehicle total'}: ${totalPriceCar ?? '—'} ${isArabic ? 'ر.س' : 'SAR'}'),
            ]),
        const Divider(),
        OrderLineItemsWidget(items: items, isArabic: isArabic),
      ]),
    );
  }
}
