import 'package:flutter/material.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/api_functions/statistics/get_provider_main_service_statistics_model/sub_service_summaries_request.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../features/internal_orders/custom_widget/row_circle_color_text_percentage_widget.dart';

class ServicesLegendList extends StatelessWidget {

  /// قائمة الخدمات القادمة من الـ API
  final List<SubServiceSummariesRequest> services;

  const ServicesLegendList({
    super.key,
    required this.services,
  });

  /// ترتيب الخدمات حسب عدد الطلبات (من الأكبر إلى الأصغر)
  List<SubServiceSummariesRequest> get _sortedServices {
    final sorted = List<SubServiceSummariesRequest>.from(services);

    sorted.sort(
          (a, b) => (b.orderCount ?? 0).compareTo(a.orderCount ?? 0),
    );

    return sorted;
  }

  @override
  Widget build(BuildContext context) {

    /// تحديد اللغة الحالية
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    /// إذا لم توجد بيانات لا نعرض شيء
    if (services.isEmpty) {
      return const SizedBox();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sortedServices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {

        final service = _sortedServices[index];
        print("services data:");
        for (var s in services) {
          print("${s.serviceName} : ${s.orderCount}");
        }
        /// اختيار اسم الخدمة حسب اللغة
        final title = isArabic
            ? (service.serviceName ?? '')
            : (service.serviceLatinName ?? '');

        /// عدد الطلبات
        final orderCount = service.orderCount ?? 0;

        return RowCircleColorTextPercentageWidget(
          colorCircle: legendColor(index),
          text: title,

          /// عرض عدد الطلبات مباشرة
          percentage: orderCount.toString(),
        );
      },
    );
  }
}