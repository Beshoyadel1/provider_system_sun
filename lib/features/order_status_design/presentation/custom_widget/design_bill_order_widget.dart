import 'package:flutter/material.dart';
import '../../../internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import '../../../../core/theming/colors.dart';
import 'order_line_items_widget.dart';
import 'user_wallet_button.dart';

class DesignBillOrderWidget extends StatelessWidget {
  const DesignBillOrderWidget({super.key, required this.order});
  final OrderDetailsModel order;

  @override
  Widget build(BuildContext context) {
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    String t(String a, String e) => ar ? a : e;
    Widget amount(String title, num? value,
            {bool discount = false, bool total = false}) =>
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Text(title)),
              const SizedBox(width: 12),
              Flexible(
                  child: Text(
                      '${discount && value != null && value > 0 ? '−' : ''}${orderAmount(value)} ${t('ر.س', 'SAR')}',
                      style: TextStyle(
                          fontWeight:
                              total ? FontWeight.bold : FontWeight.normal,
                          color: total ? AppColors.orangeColor : null))),
            ]));
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: AppColors.orangeColor.withValues(alpha: .3))),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(t('ملخص الفاتورة', 'Invoice summary'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          amount(t('قيمة الضريبة', 'Tax amount'), order.taxamount),
          if (order.hasDelivery)
            amount(t('رسوم التوصيل', 'Delivery fee'), order.deliveryOrder?.fee),
          if (order.coupon != null) ...[
            amount(t('خصم الكوبون', 'Coupon discount'), order.coupon?.amount,
                discount: true),
            if (order.coupon?.code?.isNotEmpty == true)
              Text(order.coupon!.code!),
          ],
          if (order.points != null)
            amount(t('خصم النقاط', 'Points discount'), order.points?.amount,
                discount: true),
          const Divider(),
          amount(t('الإجمالي', 'Total'), order.totalprice, total: true),
          const Divider(),
          UserWalletButton(paymentMethod: order.paymentmethod ?? -1),
          const SizedBox(height: 8),
          Text(
              t('تنزيل الفاتورة غير متاح حاليًا',
                  'Invoice download is currently unavailable'),
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]));
  }
}
