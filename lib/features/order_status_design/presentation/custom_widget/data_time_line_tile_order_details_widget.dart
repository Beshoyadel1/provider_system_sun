import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/api/dio_function/api_constants.dart';
import '../../../internal_services/data/model/get_provider_orders_model/order_details_model.dart';
import '../../../../core/theming/colors.dart';

class DataTimeLineTileOrderDetailsWidget extends StatelessWidget {
  const DataTimeLineTileOrderDetailsWidget(
      {super.key,
      this.orderStatus,
      this.isOnSite = false,
      this.history = const []});
  final int? orderStatus;
  final bool isOnSite;
  final List<StatusHistory> history;

  @override
  Widget build(BuildContext context) {
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    String t(String a, String e) => ar ? a : e;
    String status(int? value) => value == null
        ? '—'
        : ar
            ? OrderStatusToString.toArabic(value)
            : OrderStatusToString.toEnglish(value);
    final events = [...history]..sort((a, b) {
        if (a.date == null) return b.date == null ? 0 : 1;
        if (b.date == null) return -1;
        return a.date!.compareTo(b.date!);
      });
    String actor(StatusHistory event) {
      if (event.changedbyname?.trim().isNotEmpty == true)
        return event.changedbyname!;
      final role = switch (event.changedbytype) {
        UserType.appUser => t('العميل', 'Customer'),
        UserType.companyUser => t('الشركة', 'Company'),
        UserType.driverUser => t('السائق', 'Driver'),
        UserType.providerUser => t('مزود الخدمة', 'Provider'),
        UserType.employeeUser => t('الموظف', 'Employee'),
        UserType.adminUser => t('الإدارة', 'Administration'),
        _ => t('غير متاح', 'Unavailable'),
      };
      return event.changedbyid == null ? role : '$role #${event.changedbyid}';
    }

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
          Text(t('سجل حالات الطلب', 'Order status history'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (events.isEmpty) ...[
            Text(
                '${t('الحالة الحالية', 'Current status')}: ${status(orderStatus)}'),
            Text(t('لا يوجد سجل تغييرات متاح', 'No change history available')),
          ],
          for (final event in events)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.history,
                          color: AppColors.orangeColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(event.oldstatus == null
                                ? status(event.newstatus)
                                : '${status(event.oldstatus)} → ${status(event.newstatus)}'),
                            Text(actor(event)),
                            Text(event.date == null
                                ? t('التوقيت غير متاح', 'Time unavailable')
                                : DateFormat('yyyy/MM/dd HH:mm')
                                    .format(event.date!.toLocal())),
                          ])),
                    ])),
        ]));
  }
}
