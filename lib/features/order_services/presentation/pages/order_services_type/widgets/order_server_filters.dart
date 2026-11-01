import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/app_filter_dialog.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/page_size_filter.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/text_styles.dart';
import 'package:sun_web_system/features/auth_page/data/model/create_user_model/create_user_request.dart';
import 'package:sun_web_system/features/employee/data/datasource/get_provider_employees_datasource/get_provider_employees_repository.dart';
import 'package:sun_web_system/features/employee/data/request/get_provider_employees_request/get_provider_employees_repository.dart';
import 'package:sun_web_system/features/internal_services/presentation/cubit/get_provider_internal_order/get_provider_internal_order_state.dart';
import 'package:sun_web_system/features/internal_services/presentation/cubit/get_provider_internal_order/get_provider_internal_order_cubit.dart';

typedef _OrderFilterSelection = ({int? employeeId, int pageSize});

class OrderFiltersHeader extends StatelessWidget {
  const OrderFiltersHeader({super.key, required this.branchId});
  final int branchId;

  @override
  Widget build(BuildContext context) => Row(children: [
        const Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextInAppWidget(
              text: AppLanguageKeys.allOrdersKey,
              textSize: 20,
              textColor: AppColors.darkColor),
          TextInAppWidget(
              text: AppLanguageKeys.ordersListFromServicesKey,
              textSize: 16,
              textColor: AppColors.darkGreyColor),
        ])),
        const SizedBox(width: 12),
        OrderServerFilters(branchId: branchId),
      ]);
}

class OrderServerFilters extends StatelessWidget {
  const OrderServerFilters({super.key, required this.branchId});
  final int branchId;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GetProviderInternalOrderCubit, GetProviderInternalOrderState>(
        builder: (context, state) {
          final cubit = context.read<GetProviderInternalOrderCubit>();
          return AppFilterButton(
            key: const Key('order-filter-button'),
            activeCount: (cubit.selectedEmployeeId == null ? 0 : 1) +
                (cubit.pageSize == 20 ? 0 : 1),
            onPressed: () async {
              final selection = await showDialog<_OrderFilterSelection>(
                context: context,
                builder: (_) => _OrderFiltersDialog(
                    branchId: branchId,
                    employeeId: cubit.selectedEmployeeId,
                    pageSize: cubit.pageSize),
              );
              if (!context.mounted || cubit.isClosed || selection == null) {
                return;
              }
              if (selection.employeeId == cubit.selectedEmployeeId &&
                  selection.pageSize == cubit.pageSize) {
                return;
              }
              await cubit.applyServerFilters(
                  employeeId: selection.employeeId,
                  pageSize: selection.pageSize);
            },
          );
        },
      );
}

class _OrderFiltersDialog extends StatefulWidget {
  const _OrderFiltersDialog(
      {required this.branchId,
      required this.employeeId,
      required this.pageSize});
  final int branchId;
  final int? employeeId;
  final int pageSize;
  @override
  State<_OrderFiltersDialog> createState() => _OrderFiltersDialogState();
}

class _OrderFiltersDialogState extends State<_OrderFiltersDialog> {
  List<CreateUserRequest> _employees = [];
  bool _loading = true, _failed = false;
  late int? _employeeId = widget.employeeId;
  late int _pageSize = widget.pageSize;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final user = await AuthLocalStorage.getUser();
      if (user?.userid == null || user!.type != 4) {
        throw StateError('Provider unavailable');
      }
      final employees = await getProviderEmployees(
          request: GetProviderEmployeesRepository(
              provId: user.userid!,
              branchId: widget.branchId > 0 ? widget.branchId : null));
      if (!mounted) return;
      final seen = <int>{};
      setState(() {
        _employees = employees.where((employee) {
          final details = employee.employeeDetails?.employeeDetails;
          return details?.id != null &&
              details!.id! > 0 &&
              details.provid == user.userid &&
              (widget.branchId <= 0 || details.branchid == widget.branchId) &&
              seen.add(details.id!);
        }).toList();
      });
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    return AppFilterDialog(
      title: ar ? 'تصفية الطلبات' : 'Filter orders',
      onReset: () => setState(() {
        _employeeId = null;
        _pageSize = 20;
      }),
      onApply: () => Navigator.pop(
          context, (employeeId: _employeeId, pageSize: _pageSize)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        AppFilterDropdown(
          label: ar ? 'الموظف' : 'Employee',
          value: _employeeId ?? 0,
          items: {
            0: ar ? 'كل الموظفين' : 'All employees',
            if (_employeeId != null &&
                !_employees.any((employee) =>
                    employee.employeeDetails?.employeeDetails?.id ==
                    _employeeId))
              _employeeId!: '#$_employeeId',
            for (final employee in _employees)
              employee.employeeDetails!.employeeDetails!.id!:
                  employee.username ?? '#${employee.userid}',
          },
          onChanged: _loading
              ? null
              : (id) => setState(() => _employeeId = id == 0 ? null : id),
        ),
        if (_loading)
          const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(color: AppColors.orangeColor)),
        if (_failed)
          Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                  label:
                      Text(ar ? 'إعادة تحميل الموظفين' : 'Reload employees'))),
        const SizedBox(height: 22),
        PageSizeFilter(
            value: _pageSize,
            onChanged: (size) => setState(() => _pageSize = size)),
      ]),
    );
  }
}
