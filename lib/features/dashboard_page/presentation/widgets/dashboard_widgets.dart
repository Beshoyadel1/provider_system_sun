import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sun_web_system/core/language/language.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/custom_container.dart';
import 'package:sun_web_system/core/theming/colors.dart';

String dashboardLabel(BuildContext context, String key) =>
    AppLocalizations.of(context).translate(key);
String dashboardMoney(double? value) =>
    value == null ? '—' : NumberFormat('#,##0.00', 'en').format(value);

class DashboardPanel extends StatelessWidget {
  const DashboardPanel(
      {super.key,
      required this.child,
      this.height,
      this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final double? height;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => CustomContainer(
        containerHeight: height,
        containerWidth: double.infinity,
        padding: padding,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E7ED)),
        isSelected: false,
        onTap: null,
        typeWidget: child,
      );
}

class DashboardTitle extends StatelessWidget {
  const DashboardTitle(this.title, {super.key, this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(dashboardLabel(context, title),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkColor)),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(dashboardLabel(context, subtitle!),
              style: const TextStyle(
                  fontSize: 10, color: AppColors.darkGreyColor)),
        ],
      ]);
}

class DashboardFeedback extends StatelessWidget {
  const DashboardFeedback(
      {super.key,
      this.loading = false,
      this.failed = false,
      this.message,
      this.onRetry});
  final bool loading;
  final bool failed;
  final String? message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2))
            : Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                    failed ? Icons.cloud_off_outlined : Icons.insights_outlined,
                    size: 24,
                    color: const Color(0xFFA7AFBB)),
                const SizedBox(height: 8),
                Text(
                    dashboardLabel(
                        context,
                        message ??
                            (failed
                                ? AppLanguageKeys.errorLoadingData
                                : AppLanguageKeys.noDataAvailable)),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.darkGreyColor)),
                if (failed && onRetry != null)
                  TextButton(
                      onPressed: onRetry,
                      child: Text(
                          dashboardLabel(
                              context, AppLanguageKeys.dashboardRetry),
                          style: const TextStyle(fontSize: 11))),
              ]),
      ));
}

Color dashboardServiceColor(int? id) => switch (id) {
      1 => AppColors.orangeColor,
      2 => const Color(0xFF18A6B3),
      3 => const Color(0xFF5C6267),
      4 => const Color(0xFF8A63CB),
      5 => const Color(0xFFC99524),
      _ => const Color(0xFF6383AE),
    };

IconData dashboardServiceIcon(int id) => switch (id) {
      1 => Icons.car_repair_outlined,
      2 => Icons.local_shipping_outlined,
      3 => Icons.settings_outlined,
      4 => Icons.inventory_2_outlined,
      _ => Icons.local_gas_station_outlined,
    };
