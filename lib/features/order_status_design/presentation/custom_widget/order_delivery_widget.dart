import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../internal_services/data/model/get_provider_orders_model/delivery_order_model.dart';
import '../../../../core/theming/colors.dart';
import 'order_line_items_widget.dart';

class OrderDeliveryWidget extends StatelessWidget {
  const OrderDeliveryWidget({super.key, this.delivery});
  final DeliveryOrderModel? delivery;

  @override
  Widget build(BuildContext context) {
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    String label(String a, String e) => ar ? a : e;
    final status = switch (delivery?.status) {
      'new' => label('طلب توصيل جديد', 'New delivery order'),
      'accepted' =>
        label('المندوب في الطريق للفرع', 'Courier heading to branch'),
      'arrived_to_store' =>
        label('المندوب وصل للفرع', 'Courier arrived at branch'),
      'picked' => label('المندوب استلم الشحنة', 'Shipment picked up'),
      'delivered' => label('تم التوصيل', 'Delivered'),
      'cancelled' => label('تم إلغاء التوصيل', 'Delivery cancelled'),
      _ => delivery?.status ??
          label('بانتظار تحديث التوصيل', 'Awaiting delivery update'),
    };
    Widget row(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child:
            Wrap(spacing: 12, children: [Text(title), SelectableText(value)]));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.orangeColor.withValues(alpha: 0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label('توصيل الطلب', 'Order delivery'),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        row(label('الحالة', 'Status'), status),
        row(
            label('المندوب', 'Courier'),
            delivery?.courierName?.trim().isNotEmpty == true
                ? delivery!.courierName!
                : delivery?.status != null && delivery?.status != 'new'
                    ? label('اسم المندوب غير متاح', 'Courier name unavailable')
                    : label(
                        'لم يتم تعيين مندوب بعد', 'No courier assigned yet')),
        if (delivery?.courierPhone?.trim().isNotEmpty == true)
          row(label('رقم المندوب', 'Courier phone'), delivery!.courierPhone!),
        if (delivery?.fee != null)
          row(label('رسوم التوصيل', 'Delivery fee'),
              '${orderAmount(delivery!.fee)} ${label('ر.س', 'SAR')}'),
        for (final entry in {
          label('قبول المندوب', 'Courier accepted'): delivery?.acceptedAt,
          label('استلام الشحنة', 'Picked up'): delivery?.receivedAt,
          label('تسليم الشحنة', 'Delivered'): delivery?.deliveredAt,
        }.entries)
          if (entry.value != null)
            row(entry.key,
                DateFormat('yyyy/MM/dd HH:mm').format(entry.value!.toLocal())),
      ]),
    );
  }
}
