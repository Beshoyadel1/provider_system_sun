import 'package:flutter/material.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import '../../data/model/get_provider_total_rate_and_employee_and_balance_model/get_provider_total_rate_and_employee_and_balance_model.dart';
import 'dashboard_widgets.dart';

class DataAccountBalance extends StatelessWidget {
  const DataAccountBalance({super.key, required this.item});
  final AccountBalance item;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8EAF0)),
            borderRadius: BorderRadius.circular(9)),
        child: Row(children: [
          const Icon(Icons.receipt_long_outlined,
              size: 21, color: AppColors.orangeColor),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(item.getName(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.orangeColor)),
                if (item.recentOrderId != null) ...[
                  const SizedBox(height: 3),
                  Text(
                      '${dashboardLabel(context, AppLanguageKeys.dashboardOrderIncome)} #${item.recentOrderId}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 9)),
                ],
              ])),
          const SizedBox(width: 8),
          Text(dashboardMoney(item.amount),
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF23A571),
                  fontWeight: FontWeight.w500)),
        ]),
      );
}
