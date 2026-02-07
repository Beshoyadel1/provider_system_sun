import 'package:flutter/material.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../features/internal_orders/custom_widget/row_circle_color_text_percentage_widget.dart';

class ServicesLegendList extends StatelessWidget {
  final List services;

  const ServicesLegendList({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final service = services[index];

        final title = isArabic
            ? (service.serviceName ?? '')
            : (service.serviceLatinName ?? '');

        final count = service.orderCount ?? 0;

        return RowCircleColorTextPercentageWidget(
          colorCircle: legendColor(index),
          text: title,
          percentage: count.toString(),
        );
      },
    );
  }
}

Color legendColor(int index) {
  const colors = [
    AppColors.brownColor,
    AppColors.lightBlueColor,
    AppColors.greenColor,
    AppColors.orangeColor,
    AppColors.purpleColor,
  ];

  return colors[index % colors.length];
}
