import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/fonts.dart';

import '../../../auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../employee/data/datasource/get_provider_employees_by_services/get_provider_employees_by_services_repository.dart';
import '../../data/model/order_employee_assignment.dart';

Future<List<int>?> showOrderEmployeeAssignmentDialog(
  BuildContext context, {
  required OrderEmployeeAssignment assignment,
}) =>
    showDialog<List<int>>(
      context: context,
      builder: (_) => OrderEmployeeAssignmentDialog(assignment: assignment),
    );

class OrderEmployeeAssignmentDialog extends StatefulWidget {
  const OrderEmployeeAssignmentDialog({
    super.key,
    required this.assignment,
    this.employeesLoader = getProviderEmployeesByServices,
  });

  final OrderEmployeeAssignment assignment;
  final ProviderServiceEmployeesLoader employeesLoader;

  @override
  State<OrderEmployeeAssignmentDialog> createState() =>
      _OrderEmployeeAssignmentDialogState();
}

class _OrderEmployeeAssignmentDialogState
    extends State<OrderEmployeeAssignmentDialog> {
  bool _loading = true;
  String? _error;
  final _selectedIds = <int>{};
  List<CreateUserRequest> _employees = const [];

  bool get _coversServices => widget.assignment.coversServices(_employees.where(
      (employee) => _selectedIds
          .contains(employee.employeeDetails!.employeeDetails!.id)));

  bool get _canConfirm =>
      !_loading && _selectedIds.isNotEmpty && _coversServices;

  String _t(String ar, String en) =>
      Localizations.localeOf(context).languageCode == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!widget.assignment.isComplete) {
      _loading = false;
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _selectedIds.clear();
    });
    try {
      final assignment = widget.assignment;
      final employees = await widget.employeesLoader(
        providerId: assignment.providerId!,
        branchId: assignment.branchId!,
        serviceIds: assignment.serviceIds,
      );
      if (!mounted) return;
      setState(() {
        _employees = assignment.eligibleEmployees(employees);
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  Widget _content() {
    if (!widget.assignment.isComplete) {
      return Text(_t(
        'بيانات فرع الطلب أو نوع الخدمة ناقصة. حدّث تفاصيل الطلب ثم حاول مجددًا.',
        'The order branch or service details are missing. Refresh the order and try again.',
      ));
    }
    if (_loading) {
      return const SizedBox(
        height: 100,
        child: Center(
            child: CircularProgressIndicator(color: AppColors.orangeColor)),
      );
    }
    if (_error != null) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Text(_t('تعذر تحميل الموظفين', 'Could not load employees')),
        const SizedBox(height: 8),
        Text(_error!, textAlign: TextAlign.center),
        TextButton(
            onPressed: _load, child: Text(_t('إعادة المحاولة', 'Retry'))),
      ]);
    }
    if (_employees.isEmpty) {
      return Text(_t(
        'لا يوجد موظفون متاحون في فرع الطلب مسندة إليهم خدمات هذا الطلب.',
        'No available employees in this branch are assigned to the order services.',
      ));
    }
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_t('اختر موظفًا أو أكثر من فرع الطلب لتنفيذ الخدمة.',
              'Select one or more employees from the order branch to perform the service.')),
          const SizedBox(height: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: _employees.map((employee) {
              final id = employee.employeeDetails!.employeeDetails!.id!;
              final selected = _selectedIds.contains(id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: selected
                      ? AppColors.orangeColor.withValues(alpha: .08)
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  child: CheckboxListTile(
                    value: selected,
                    onChanged: (checked) => setState(() {
                      if (checked == true) {
                        _selectedIds.add(id);
                      } else {
                        _selectedIds.remove(id);
                      }
                    }),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.orangeColor,
                    selected: selected,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: selected
                              ? AppColors.orangeColor
                              : AppColors.lightGreyColor),
                    ),
                    title: Text(employee.username ?? employee.email ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontFamily: AppFonts.readexProFontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkColor)),
                    subtitle: employee.phone?.isNotEmpty == true
                        ? Text(employee.phone!,
                            textDirection: TextDirection.ltr,
                            textAlign:
                                Directionality.of(context) == TextDirection.rtl
                                    ? TextAlign.right
                                    : TextAlign.left,
                            style: const TextStyle(
                                fontFamily: AppFonts.readexProFontFamily,
                                fontSize: 12,
                                color: AppColors.darkGreyColor))
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          if (_selectedIds.isNotEmpty && !_coversServices)
            Text(
                _t('اختر موظفين لتغطية كل خدمات الطلب.',
                    'Select employees to cover all the order services.'),
                style: const TextStyle(color: AppColors.darkorangeColor)),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
            primary: AppColors.orangeColor,
            onPrimary: AppColors.whiteColor,
            surface: AppColors.whiteColor,
            onSurface: AppColors.darkColor,
            surfaceTint: AppColors.transparent),
        textTheme:
            theme.textTheme.apply(fontFamily: AppFonts.readexProFontFamily),
      ),
      child: AlertDialog(
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.lightGreyColor)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        titleTextStyle: const TextStyle(
            fontFamily: AppFonts.readexProFontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.darkColor),
        contentTextStyle: const TextStyle(
            fontFamily: AppFonts.readexProFontFamily,
            fontSize: 14,
            height: 1.6,
            color: AppColors.darkGreyColor),
        title: Row(children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: AppColors.orangeColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.person_add_alt_1_outlined,
                  color: AppColors.orangeColor, size: 24)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(
                  _t('إسناد الطلب للموظفين', 'Assign order to employees'))),
        ]),
        content: SizedBox(
          width: 440,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .45),
            child: SingleChildScrollView(child: _content()),
          ),
        ),
        actions: [
          Row(children: [
            Expanded(
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkGreyColor,
                      side: const BorderSide(color: AppColors.lightGreyColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      textStyle: const TextStyle(
                          fontFamily: AppFonts.readexProFontFamily,
                          fontSize: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(_t('إلغاء', 'Cancel')))),
            const SizedBox(width: 12),
            Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orangeColor,
                    foregroundColor: AppColors.whiteColor,
                    disabledBackgroundColor: AppColors.veryLightGreyColor,
                    disabledForegroundColor: AppColors.darkGreyColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    textStyle: const TextStyle(
                        fontFamily: AppFonts.readexProFontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: !_canConfirm
                      ? null
                      : () =>
                          Navigator.pop(context, _selectedIds.toList()..sort()),
                  child: Text(
                      _t('قبول وإسناد الطلب', 'Accept and assign order'),
                      textAlign: TextAlign.center),
                )),
          ]),
        ],
      ),
    );
  }
}
