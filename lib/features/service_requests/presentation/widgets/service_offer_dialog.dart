import 'package:flutter/material.dart';

import '../../../../core/setup_git_it.dart';
import '../../../../core/theming/auth_local_storage.dart';
import '../../../../core/theming/colors.dart';
import '../../../auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../employee/data/datasource/get_branch_employees_datasource/get_branch_employees_datasource.dart';
import '../../../employee/data/request/get_branch_employees_request/get_branch_employees_request.dart';
import '../../../service_settings/data/datasource/get_prov_services_datasource/get_prov_services_repository.dart';
import '../../../service_settings/data/request/get_prov_services_request/get_prov_services_request.dart';
import '../../../service_settings/data/response/get_prov_services_response/get_prov_services_response.dart';
import '../../../store_page/data/model/get_provider_branches_model/provider_branch_model.dart';
import '../../../store_page/presentation/bloc/branch_cubit/branch_cubit.dart';
import '../../data/model/service_request_model.dart';
import '../../data/request/service_offer_request.dart';

Future<ServiceOfferRequest?> showServiceOfferDialog({
  required BuildContext context,
  required ServiceRequestModel request,
  ServiceRequestOffer? offer,
}) {
  return showDialog<ServiceOfferRequest>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.darkColor.withValues(alpha: .5),
    builder: (_) => ServiceOfferDialog(request: request, offer: offer),
  );
}

class ServiceOfferDialog extends StatefulWidget {
  const ServiceOfferDialog({
    super.key,
    required this.request,
    this.offer,
  });

  final ServiceRequestModel request;
  final ServiceRequestOffer? offer;

  @override
  State<ServiceOfferDialog> createState() => _ServiceOfferDialogState();
}

class _ServiceOfferDialogState extends State<ServiceOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _costController;

  bool _loading = true;
  bool _loadingEmployees = false;
  String? _error;
  int? _providerId;
  int? _branchId;
  int? _employeeId;
  int? _providerServiceId;
  List<ProviderBranchModel> _branches = const [];
  List<CreateUserRequest> _employees = const [];
  List<GetProvServicesResponse> _providerServices = const [];

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';
  String _t(String ar, String en) => _isArabic ? ar : en;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.offer?.price.price.toStringAsFixed(2) ?? '',
    );
    _costController = TextEditingController(
      text: widget.offer?.cost.toStringAsFixed(2) ?? '',
    );
    _loadOptions();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    try {
      final user = await AuthLocalStorage.getUser();
      final providerId = user?.userid;
      if (providerId == null || providerId <= 0) {
        throw Exception('User not found');
      }

      final branchCubit = getIt<BranchCubit>();
      if (branchCubit.branches.isEmpty) {
        await branchCubit.getProviderBranches();
      }

      final providerServices = await getProvServicesFunction(
        getProvServicesRequest: GetProvServicesRequest(
          providerId: providerId,
          serviceId: widget.request.service.id,
        ),
      );

      final branches = branchCubit.branches
          .where((branch) =>
              branch.isActive != false && (branch.branchId ?? 0) > 0)
          .toList(growable: false);
      final availableServices = providerServices
          .where((item) =>
              item.provService.id > 0 &&
              item.provService.serviceid == widget.request.service.id &&
              item.provService.provid == providerId)
          .toList(growable: false);
      final preferredBranch = widget.offer?.branch.id ??
          (branchCubit.selectedBranchId > 0
              ? branchCubit.selectedBranchId
              : null);
      final selectedBranch = branches.any((b) => b.branchId == preferredBranch)
          ? preferredBranch
          : null;

      if (!mounted) return;
      setState(() {
        _providerId = providerId;
        _branches = branches;
        _providerServices = availableServices;
        _branchId = selectedBranch;
        _providerServiceId = null;
        _loading = false;
      });

      if (selectedBranch != null) await _loadEmployees(selectedBranch);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _loadEmployees(int branchId) async {
    final providerId = _providerId;
    if (providerId == null) return;
    setState(() {
      _loadingEmployees = true;
      _employeeId = null;
    });
    try {
      final employees = await getBranchEmployeesFunction(
        getBranchEmployeesRequest: GetBranchEmployeesRequest(
          providerId: providerId,
          branchId: branchId,
        ),
      );
      final preferredEmployee = widget.offer?.employee.id;
      int? selected;
      for (final employee in employees) {
        final id = _employeeDetailsId(employee);
        if (id == preferredEmployee) selected = id;
      }
      if (!mounted) return;
      setState(() {
        _employees = employees;
        _employeeId = selected;
        _loadingEmployees = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _employees = const [];
        _loadingEmployees = false;
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  int? _employeeDetailsId(CreateUserRequest employee) {
    return employee.employeeDetails?.employeeDetails?.id;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final selectedService = _providerServices
        .where((item) => item.provService.id == _providerServiceId)
        .firstOrNull;
    if ((_providerId ?? 0) <= 0 ||
        (_branchId ?? 0) <= 0 ||
        (_employeeId ?? 0) <= 0 ||
        widget.request.id <= 0 ||
        widget.request.service.id <= 0 ||
        selectedService == null ||
        selectedService.provService.taxid <= 0) {
      setState(() => _error = _t(
            'يرجى استكمال بيانات الفرع والموظف والخدمة',
            'Please complete branch, employee, and service data',
          ));
      return;
    }

    Navigator.of(context).pop(
      ServiceOfferRequest(
        id: widget.offer?.id,
        serviceRequestId: widget.request.id,
        providerId: _providerId!,
        branchId: _branchId!,
        price: double.parse(_priceController.text.trim()),
        cost: double.parse(_costController.text.trim()),
        serviceId: widget.request.service.id,
        taxId: selectedService.provService.taxid,
        employeeId: _employeeId!,
        providerServiceId: selectedService.provService.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      title: Text(
        widget.offer == null
            ? _t('تقديم عرض', 'Submit offer')
            : _t('تعديل العرض', 'Edit offer'),
      ),
      content: SizedBox(
        width: 560,
        child: _loading
            ? const SizedBox(
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.orangeColor,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_error != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.pinkColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: AppColors.darkorangeColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      _numberField(
                        controller: _priceController,
                        label: _t('سعر العرض', 'Offer price'),
                      ),
                      const SizedBox(height: 12),
                      _numberField(
                        controller: _costController,
                        label: _t('التكلفة', 'Cost'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        dropdownColor: AppColors.whiteColor,
                        iconEnabledColor: AppColors.orangeColor,
                        key: ValueKey('branch-$_branchId'),
                        initialValue: _branchId,
                        decoration: _decoration(_t('الفرع', 'Branch')),
                        items: _branches
                            .map((branch) => DropdownMenuItem(
                                  value: branch.branchId,
                                  child: Text(_isArabic
                                      ? branch.branchName ?? ''
                                      : branch.branchLatinName ?? ''),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _branchId = value);
                          _loadEmployees(value);
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        dropdownColor: AppColors.whiteColor,
                        iconEnabledColor: AppColors.orangeColor,
                        key: ValueKey('provider-service-$_providerServiceId'),
                        initialValue: _providerServiceId,
                        decoration: _decoration(
                          _t('خدمة المزود', 'Provider service'),
                        ),
                        items: _providerServices
                            .map((item) => DropdownMenuItem(
                                  value: item.provService.id,
                                  child: Text(_isArabic
                                      ? item.provService.name
                                      : item.provService.latinname),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _providerServiceId = value),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        dropdownColor: AppColors.whiteColor,
                        iconEnabledColor: AppColors.orangeColor,
                        key: ValueKey('employee-$_employeeId'),
                        initialValue: _employeeId,
                        decoration: _decoration(_loadingEmployees
                            ? _t('جاري تحميل الموظفين...',
                                'Loading employees...')
                            : _t('الموظف', 'Employee')),
                        items: _employees
                            .where((employee) =>
                                (_employeeDetailsId(employee) ?? 0) > 0)
                            .map((employee) => DropdownMenuItem(
                                  value: _employeeDetailsId(employee),
                                  child: Text(employee.username ??
                                      employee.email ??
                                      ''),
                                ))
                            .toList(),
                        onChanged: _loadingEmployees
                            ? null
                            : (value) => setState(() => _employeeId = value),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.darkGreyColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_t('إلغاء', 'Cancel')),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.orangeColor),
          onPressed: _loading ? null : _submit,
          child: Text(_t('حفظ', 'Save')),
        ),
      ],
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.orangeColor,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: _decoration(label),
      validator: (value) {
        final number = double.tryParse(value?.trim() ?? '');
        if (number == null || number < 0) {
          return _t('أدخل قيمة صحيحة', 'Enter a valid value');
        }
        return null;
      },
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: const TextStyle(color: AppColors.orangeColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.orangeColor, width: 1.5),
      ),
    );
  }
}
