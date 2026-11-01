import 'package:sun_web_system/core/api/api_json.dart';
import 'package:flutter/material.dart';
import '../dashboard_service.dart';
import '../../../../../core/language/language_cubit/language_cubit.dart';

class GetProviderTotalRateAndEmployeeAndBalanceModel {
  final double? averageRate;
  final double? totalBalance;
  final List<TopEmployee> topEmployees;
  final List<AccountBalance> accountsBalance;

  GetProviderTotalRateAndEmployeeAndBalanceModel({
    this.averageRate,
    this.totalBalance,
    required this.topEmployees,
    required this.accountsBalance,
  });

  factory GetProviderTotalRateAndEmployeeAndBalanceModel.fromJson(
      Map<String, dynamic> json) {
    json = ApiJson.object(json);

    final raw = json['data'];
    if (raw is! Map) {
      throw const FormatException('Invalid performance response');
    }
    final data = ApiJson.object(raw);

    return GetProviderTotalRateAndEmployeeAndBalanceModel(
      averageRate: dashboardNumber(data['averageRate']),
      totalBalance: dashboardNumber(data['totalBalance']),
      topEmployees: (data['topEmployees'] as List<dynamic>?)
              ?.map((e) => TopEmployee.fromJson(e))
              .toList() ??
          [],
      accountsBalance: (data['accountsBalance'] is List
                  ? data['accountsBalance'] as List<dynamic>
                  : null)
              ?.map((e) => AccountBalance.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TopEmployee {
  final String? employeeName;
  final String? employeeLatinName;
  final int? orderCount;
  final String? jobName;
  final String? jobLatinName;

  TopEmployee({
    this.employeeName,
    this.employeeLatinName,
    this.orderCount,
    this.jobName,
    this.jobLatinName,
  });

  factory TopEmployee.fromJson(Map<String, dynamic> json) {
    json = ApiJson.object(json);
    return TopEmployee(
      employeeName: json['employeeName']?.toString(),
      employeeLatinName: json['employeeLatinName']?.toString(),
      orderCount: dashboardInt(json['orderCount']),
      jobName: json['jobName']?.toString(),
      jobLatinName: json['jobLatinName']?.toString(),
    );
  }

  String getName(BuildContext context) {
    return LanguageCubit.localizedValue(
        context, employeeName, employeeLatinName);
  }

  String getJobName(BuildContext context) {
    return LanguageCubit.localizedValue(context, jobName, jobLatinName);
  }
}

class AccountBalance {
  final String? serviceName;
  final String? serviceLatinName;
  final double? amount;
  final int? recentOrderId;

  AccountBalance({
    this.serviceName,
    this.serviceLatinName,
    this.amount,
    this.recentOrderId,
  });

  factory AccountBalance.fromJson(Map<String, dynamic> json) {
    json = ApiJson.object(json);
    return AccountBalance(
      serviceName: json['serviceName']?.toString(),
      serviceLatinName: json['serviceLatinName']?.toString(),
      amount: dashboardNumber(json['amount']),
      recentOrderId: dashboardInt(json['recentOrderId']),
    );
  }

  String getName(BuildContext context) {
    return LanguageCubit.localizedValue(context, serviceName, serviceLatinName);
  }
}
