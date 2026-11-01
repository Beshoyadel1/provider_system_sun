import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/cubit/app_cubit/app_cubit.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/setup_git_it.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/theming/fonts.dart';
import 'package:sun_web_system/core/utilies/map_of_all_app.dart';
import 'cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_cubit.dart';
import 'cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_cubit.dart';
import 'cubit/get_provider_total_rate_and_employee_and_balance_cubit/get_provider_total_rate_and_employee_and_balance_cubit.dart';
import 'widgets/account_balance.dart';
import 'widgets/chart_order.dart';
import 'widgets/dashboard_widgets.dart';
import 'widgets/employees_performance.dart';
import 'widgets/list_custom_chart.dart';
import 'widgets/services_evaluation.dart';
import 'widgets/services_statistics.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, this.branchId = 0});
  final int branchId;
  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(
            create: (_) => GetProviderServiceStatisticsCubit()
              ..getProviderServiceStatistics(branchId: branchId)),
        BlocProvider(
            create: (_) => GetProviderOrdersSalesCubit()
              ..getProviderOrdersSales(branchId: branchId)),
        BlocProvider(
            create: (_) => GetProviderTotalRateAndEmployeeAndBalanceCubit()
              ..getProviderTotalRateAndEmployeeAndBalance(branchId: branchId)),
      ], child: DashboardContent(branchId: branchId));
}

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key, this.branchId = 0, this.onBalanceDetails});
  final int branchId;
  final VoidCallback? onBalanceDetails;
  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  DateTimeRange? _period;
  String? _date(DateTime? value) => value?.toIso8601String().split('T').first;

  void _reload({bool performance = true}) {
    context
        .read<GetProviderServiceStatisticsCubit>()
        .getProviderServiceStatistics(
            branchId: widget.branchId,
            startDate: _date(_period?.start),
            endDate: _date(_period?.end));
    context.read<GetProviderOrdersSalesCubit>().getProviderOrdersSales(
        branchId: widget.branchId,
        startDate: _date(_period?.start),
        endDate: _date(_period?.end));
    if (performance) {
      context
          .read<GetProviderTotalRateAndEmployeeAndBalanceCubit>()
          .getProviderTotalRateAndEmployeeAndBalance(branchId: widget.branchId);
    }
  }

  Future<void> _selectPeriod() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2018),
      lastDate: today,
      initialDateRange: _period ??
          DateTimeRange(
              start: today.subtract(const Duration(days: 29)), end: today),
      builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(primary: AppColors.orangeColor)),
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
              width: 520,
              height: (MediaQuery.sizeOf(context).height -
                      MediaQuery.viewInsetsOf(context).bottom -
                      64)
                  .clamp(0.0, 600.0),
              child: child!,
            ),
          )),
    );
    if (!mounted || selected == null) return;
    setState(() => _period = selected);
    _reload(performance: false);
  }

  void _balanceDetails() {
    if (widget.onBalanceDetails != null) return widget.onBalanceDetails!();
    if (getIt.isRegistered<AppCubit>()) {
      getIt<AppCubit>().navigateToPage(PagesOfAllApp.walletPageNumber);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: DefaultTextStyle.merge(
          style: const TextStyle(
              fontFamily: AppFonts.readexProFontFamily,
              color: AppColors.darkColor),
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LayoutBuilder(builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 1100;
                    final balance = AccountBalance(
                        onDetails: _balanceDetails, onRetry: _reload);
                    final distribution = ServicesStatistics.general(
                        onRetry: () => _reload(performance: false));
                    final employees = EmployeesPerformance(onRetry: _reload);
                    final content = wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Expanded(
                                    flex: 6,
                                    child: SizedBox(
                                        height: 520,
                                        child: ChartOrder(
                                            onRetry: () =>
                                                _reload(performance: false)))),
                                const SizedBox(width: 14),
                                Expanded(
                                    flex: 3,
                                    child: Column(children: [
                                      const ServicesEvaluation(),
                                      const SizedBox(height: 14),
                                      employees
                                    ])),
                                const SizedBox(width: 14),
                                Expanded(
                                    flex: 4,
                                    child: Column(children: [
                                      distribution,
                                      const SizedBox(height: 14),
                                      balance
                                    ])),
                              ])
                        : Column(children: [
                            ChartOrder(
                                onRetry: () => _reload(performance: false)),
                            const SizedBox(height: 14),
                            if (constraints.maxWidth >= 680) ...[
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: distribution),
                                    const SizedBox(width: 14),
                                    Expanded(child: balance)
                                  ]),
                              const SizedBox(height: 14),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: employees),
                                    const SizedBox(width: 14),
                                    const Expanded(child: ServicesEvaluation())
                                  ]),
                            ] else ...[
                              distribution,
                              const SizedBox(height: 14),
                              const ServicesEvaluation(),
                              const SizedBox(height: 14),
                              employees,
                              const SizedBox(height: 14),
                              balance,
                            ],
                          ]);
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                              spacing: 14,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const DashboardTitle(
                                    AppLanguageKeys.dashboardOverview),
                                OutlinedButton.icon(
                                    onPressed: _selectPeriod,
                                    icon: const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 15),
                                    style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                            AppColors.darkGreyColor,
                                        side: const BorderSide(
                                            color: Color(0xFFE0E4EC)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(11)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 14)),
                                    label: Text(
                                        _period == null
                                            ? dashboardLabel(
                                                context,
                                                AppLanguageKeys
                                                    .dashboardAllTime)
                                            : '${_date(_period!.start)}  –  ${_date(_period!.end)}',
                                        style: const TextStyle(fontSize: 11))),
                                if (_period != null)
                                  IconButton(
                                      onPressed: () {
                                        setState(() => _period = null);
                                        _reload(performance: false);
                                      },
                                      tooltip: dashboardLabel(context,
                                          AppLanguageKeys.dashboardResetPeriod),
                                      icon: const Icon(Icons.close, size: 18)),
                                IconButton(
                                    onPressed: _reload,
                                    tooltip: dashboardLabel(context,
                                        AppLanguageKeys.dashboardRefresh),
                                    icon: const Icon(Icons.refresh_rounded,
                                        size: 20,
                                        color: AppColors.orangeColor)),
                              ]),
                          const SizedBox(height: 16),
                          ListCustomChart(
                              onRetry: () => _reload(performance: false)),
                          const SizedBox(height: 16),
                          content,
                        ]);
                  }))),
        ),
      );
}
