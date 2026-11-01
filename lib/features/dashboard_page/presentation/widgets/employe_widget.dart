import 'package:flutter/material.dart';
import 'package:sun_web_system/core/theming/assets.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import '../../data/model/get_provider_total_rate_and_employee_and_balance_model/get_provider_total_rate_and_employee_and_balance_model.dart';

class EmployeWidget extends StatelessWidget {
  const EmployeWidget({super.key, required this.employee});
  final TopEmployee employee;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8EAF0)),
            borderRadius: BorderRadius.circular(11)),
        child: Row(children: [
          CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFFFFF0E9),
              child: Image.asset(AppImageKeys.profileImage,
                  width: 21, height: 21)),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(employee.getName(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600)),
                if (employee.getJobName(context).isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(employee.getJobName(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.darkGreyColor)),
                ],
              ])),
          const SizedBox(width: 6),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF0E9),
                  borderRadius: BorderRadius.circular(7)),
              child: Text('${employee.orderCount ?? '—'}',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.orangeColor))),
        ]),
      );
}
