import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/pages_widgets/general_widgets/snakbar.dart';
import '../../../../core/setup_git_it.dart';
import '../../../../core/theming/colors.dart';
import '../../data/model/service_request_model.dart';
import '../cubit/service_requests_cubit.dart';
import '../cubit/service_requests_state.dart';
import '../widgets/service_offer_dialog.dart';

class ServiceRequestsPage extends StatelessWidget {
  const ServiceRequestsPage({super.key, this.initialRequestId});
  final int? initialRequestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ServiceRequestsCubit>(),
      child: _ServiceRequestsView(initialRequestId: initialRequestId),
    );
  }
}

class _ServiceRequestsView extends StatefulWidget {
  const _ServiceRequestsView({this.initialRequestId});
  final int? initialRequestId;

  @override
  State<_ServiceRequestsView> createState() => _ServiceRequestsViewState();
}

class _ServiceRequestsViewState extends State<_ServiceRequestsView> {
  late final ServiceRequestsCubit _cubit;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';
  String _t(String ar, String en) => _isArabic ? ar : en;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ServiceRequestsCubit>();
    _cubit.enterPage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.initialRequestId != null) {
        _cubit.openDetails(widget.initialRequestId!);
      } else {
        _cubit.closeDetails();
        _cubit.loadRequests();
      }
    });
  }

  @override
  void dispose() {
    _cubit.leavePage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceRequestsCubit, ServiceRequestsState>(
      listener: (context, state) {
        if (state is ServiceRequestsError) {
          AppSnackBar.showError(state.message);
        } else if (state is ServiceRequestSavedRefreshError) {
          AppSnackBar.showError(_t(
              'تم حفظ العرض، لكن تعذر تحديث التفاصيل. حدّث الطلب للمراجعة.',
              'The offer was saved, but details could not be refreshed. Refresh the request.'));
        } else if (state is ServiceRequestOperationSuccess) {
          AppSnackBar.showSuccess(
            state.message ?? _t('تمت العملية بنجاح', 'Completed successfully'),
          );
        }
      },
      builder: (context, state) {
        final isBusy = state is ServiceRequestOperationLoading ||
            state is ServiceRequestDetailsLoading;
        return Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _cubit.selectedRequest == null
                  ? _buildRequests(state)
                  : _buildDetails(_cubit.selectedRequest!),
            ),
            if (isBusy)
              Positioned.fill(
                child: ColoredBox(
                  color: AppColors.darkColor.withValues(alpha: .16),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.orangeColor,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRequests(ServiceRequestsState state) {
    if (state is ServiceRequestsLoading && _cubit.requests.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.orangeColor),
      );
    }

    return Padding(
      key: const ValueKey('service-request-list'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PageHeader(
            title: _t('طلبات الخدمة المفتوحة', 'Open service requests'),
            subtitle: _t(
              'راجع طلبات العملاء وقدّم العرض المناسب',
              'Review customer requests and submit the right offer',
            ),
            action: IconButton(
              tooltip: _t('تحديث', 'Refresh'),
              onPressed: () => _cubit.loadRequests(force: true),
              icon: const Icon(Icons.refresh_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.pinkColor,
                foregroundColor: AppColors.orangeColor,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: _cubit.requests.isEmpty
                ? _EmptyRequests(
                    title: _t('لا توجد طلبات مفتوحة', 'No open requests'),
                    subtitle: _t(
                      'ستظهر الطلبات الجديدة هنا فور وصولها',
                      'New requests will appear here as soon as they arrive',
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 1180
                          ? 3
                          : constraints.maxWidth >= 720
                              ? 2
                              : 1;
                      return GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 240,
                        ),
                        itemCount: _cubit.requests.length,
                        itemBuilder: (context, index) {
                          final request = _cubit.requests[index];
                          return _RequestCard(
                            request: request,
                            isArabic: _isArabic,
                            onTap: () => _cubit.openDetails(request.id),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(ServiceRequestModel request) {
    return SingleChildScrollView(
      key: ValueKey('service-request-${request.id}'),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PageHeader(
                title: _t('تفاصيل طلب الخدمة', 'Service request details'),
                subtitle: '#${request.id}',
                leading: IconButton(
                  tooltip: _t('رجوع', 'Back'),
                  onPressed: () {
                    _cubit.closeDetails();
                    _cubit.loadRequests();
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                action: IconButton(
                  tooltip: _t('تحديث', 'Refresh'),
                  onPressed: () => _cubit.openDetails(request.id, force: true),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  _DetailsSection(
                    title: _t('بيانات العميل', 'Customer'),
                    icon: Icons.person_outline_rounded,
                    children: [
                      _InfoRow(
                        label: _t('الاسم', 'Name'),
                        value: request.user.name,
                      ),
                      _InfoRow(
                        label: _t('الهاتف', 'Phone'),
                        value: request.user.phone,
                      ),
                      _InfoRow(
                        label: _t('البريد الإلكتروني', 'Email'),
                        value: request.user.email,
                      ),
                    ],
                  ),
                  _DetailsSection(
                    title: _t('بيانات السيارة', 'Car'),
                    icon: Icons.directions_car_outlined,
                    children: [
                      _InfoRow(
                        label: _t('الماركة', 'Brand'),
                        value: _isArabic
                            ? request.car.brandName
                            : request.car.brandLatinName,
                      ),
                      _InfoRow(
                        label: _t('الموديل', 'Model'),
                        value: request.car.name,
                      ),
                      _InfoRow(
                        label: _t('رقم اللوحة', 'Plate number'),
                        value: request.car.plateNo,
                      ),
                      _InfoRow(
                        label: _t('رقم الشاسيه', 'Chassis number'),
                        value: request.car.chassisNo,
                      ),
                    ],
                  ),
                  _DetailsSection(
                    title: _t('بيانات الطلب', 'Request'),
                    icon: Icons.receipt_long_outlined,
                    children: [
                      _InfoRow(
                        label: _t('الخدمة', 'Service'),
                        value: _isArabic
                            ? request.service.name
                            : request.service.latinName,
                      ),
                      _InfoRow(
                        label: _t('السعر المقترح', 'Requested price'),
                        value: '${_money(request.price)} ${_t('ر.س', 'SAR')}',
                      ),
                      _InfoRow(
                        label: _t('الموعد', 'Appointment'),
                        value: _dateTime(request.appointment),
                      ),
                      _InfoRow(
                        label: _t('تاريخ الطلب', 'Created at'),
                        value: _dateTime(request.date),
                      ),
                      _InfoRow(
                        label: _t('عدد العروض', 'Offers'),
                        value: '${request.offersCount}',
                      ),
                    ],
                  ),
                  _DetailsSection(
                    title: _t('الموقع والملاحظات', 'Location & notes'),
                    icon: Icons.location_on_outlined,
                    children: [
                      _InfoRow(
                        label: _t('خط العرض', 'Latitude'),
                        value: request.lat?.toStringAsFixed(6) ?? '-',
                      ),
                      _InfoRow(
                        label: _t('خط الطول', 'Longitude'),
                        value: request.long?.toStringAsFixed(6) ?? '-',
                      ),
                      _InfoRow(
                        label: _t('الملاحظات', 'Notes'),
                        value: request.notes.isEmpty ? '-' : request.notes,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _OffersSection(
                canEdit: _cubit.canEditSelected,
                offers: request.offers,
                isArabic: _isArabic,
                onEdit: (offer) => _showOffer(request, offer),
                onDelete: _confirmDeleteOffer,
              ),
              if (!request.isOpen)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                      _t('هذا الطلب لم يعد متاحًا لتقديم عروض.',
                          'This request is no longer open for offers.'),
                      style: const TextStyle(color: AppColors.darkorangeColor)),
                ),
              const SizedBox(height: 18),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 12,
                runSpacing: 10,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkorangeColor,
                      side: const BorderSide(color: AppColors.darkorangeColor),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                    ),
                    onPressed: _cubit.canEditSelected ? _confirmRefuse : null,
                    icon: const Icon(Icons.close_rounded),
                    label: Text(_t('رفض الطلب', 'Refuse request')),
                  ),
                  if (_cubit.canEditSelected &&
                      request.offers.isEmpty &&
                      !request.hasMyOffer)
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.orangeColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () => _showOffer(request, null),
                      icon: const Icon(Icons.local_offer_outlined),
                      label: Text(_t('تقديم عرض', 'Submit offer')),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showOffer(
    ServiceRequestModel request,
    ServiceRequestOffer? offer,
  ) async {
    final mutation = await showServiceOfferDialog(
      context: context,
      request: request,
      offer: offer,
    );
    if (mutation == null || !mounted) return;
    if (offer == null) {
      await _cubit.createOffer(mutation);
    } else {
      await _cubit.updateOffer(mutation);
    }
  }

  Future<void> _confirmDeleteOffer(ServiceRequestOffer offer) async {
    final confirmed = await _confirm(
      title: _t('حذف العرض', 'Delete offer'),
      message: _t(
        'هل أنت متأكد من حذف هذا العرض؟',
        'Are you sure you want to delete this offer?',
      ),
      confirmText: _t('حذف', 'Delete'),
    );
    if (confirmed) await _cubit.deleteOffer(offer.id);
  }

  Future<void> _confirmRefuse() async {
    final confirmed = await _confirm(
      title: _t('رفض الطلب', 'Refuse request'),
      message: _t(
        'لن يظهر الطلب لك مرة أخرى بعد الرفض. هل تريد المتابعة؟',
        'This request will no longer appear after refusal. Continue?',
      ),
      confirmText: _t('رفض', 'Refuse'),
    );
    if (confirmed) await _cubit.refuseSelectedRequest();
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmText,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierColor: AppColors.darkColor.withValues(alpha: .5),
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.whiteColor,
            surfaceTintColor: AppColors.whiteColor,
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.darkGreyColor,
                ),
                onPressed: () => Navigator.pop(context, false),
                child: Text(_t('إلغاء', 'Cancel')),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.darkorangeColor,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmText),
              ),
            ],
          ),
        ) ??
        false;
  }

  static String _dateTime(DateTime? value) {
    if (value == null) return '-';
    String two(int number) => number.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)}  '
        '${two(value.hour)}:${two(value.minute)}';
  }

  static String _money(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.subtitle,
    this.leading,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 8)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkColor,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.darkGreyColor),
              ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.isArabic,
    required this.onTap,
  });

  final ServiceRequestModel request;
  final bool isArabic;
  final VoidCallback onTap;

  String _t(String ar, String en) => isArabic ? ar : en;

  String _offerCountLabel(int count) {
    if (!isArabic) return '$count ${count == 1 ? 'offer' : 'offers'}';
    if (count == 0) return 'لا توجد عروض';
    if (count == 1) return 'عرض واحد';
    if (count == 2) return 'عرضان';
    if (count <= 10) return '$count عروض';
    return '$count عرضًا';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightGreyColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.pinkColor,
                    foregroundColor: AppColors.orangeColor,
                    child: Text(
                      request.user.name.isEmpty
                          ? '?'
                          : request.user.name.characters.first.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '#${request.id}',
                          style: const TextStyle(
                            color: AppColors.darkGreyColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (request.hasMyOffer)
                    _StatusChip(label: _t('تم تقديم عرض', 'Offer sent')),
                ],
              ),
              const SizedBox(height: 14),
              _CardLine(
                icon: Icons.build_outlined,
                label: isArabic || request.service.latinName.isEmpty
                    ? request.service.name
                    : request.service.latinName,
              ),
              const SizedBox(height: 8),
              _CardLine(
                icon: Icons.directions_car_outlined,
                label: '${request.car.name} • ${request.car.plateNo}',
              ),
              const Spacer(),
              const Divider(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_t('السعر المطلوب', 'Requested price')}: '
                      '${_ServiceRequestsViewState._money(request.price)} '
                      '${_t('ر.س', 'SAR')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.orangeColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    _offerCountLabel(request.offersCount),
                    style: const TextStyle(color: AppColors.darkGreyColor),
                  ),
                  const SizedBox(width: 8),
                  Icon(isArabic
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardLine extends StatelessWidget {
  const _CardLine({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.orangeColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.blackColor44),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.pinkColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.darkorangeColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 535),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGreyColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.orangeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.darkGreyColor),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _OffersSection extends StatelessWidget {
  const _OffersSection({
    required this.offers,
    required this.isArabic,
    required this.onEdit,
    required this.onDelete,
    required this.canEdit,
  });

  final List<ServiceRequestOffer> offers;
  final bool canEdit;
  final bool isArabic;
  final ValueChanged<ServiceRequestOffer> onEdit;
  final ValueChanged<ServiceRequestOffer> onDelete;

  String _t(String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _t('عروضي على الطلب', 'My offers'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (offers.isEmpty)
            Text(
              _t('لم تقدّم عرضًا على هذا الطلب بعد',
                  'You have not submitted an offer yet'),
              style: const TextStyle(color: AppColors.darkGreyColor),
            )
          else
            ...offers.map(
              (offer) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.scaffoldColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 8,
                  children: [
                    Text(
                      '${_t('السعر', 'Price')}: '
                      '${_ServiceRequestsViewState._money(offer.price.price)} '
                      '${_t('ر.س', 'SAR')}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${_t('الإجمالي شامل الضريبة', 'Total with tax')}: '
                      '${_ServiceRequestsViewState._money(offer.price.totalPrice)} '
                      '${_t('ر.س', 'SAR')}',
                    ),
                    Text(
                      '${_t('الفرع', 'Branch')}: '
                      '${isArabic ? offer.branch.name : offer.branch.latinName}',
                    ),
                    Text('${_t('الموظف', 'Employee')}: ${offer.employee.name}'),
                    const SizedBox(width: 12),
                    IconButton(
                      tooltip: _t('تعديل', 'Edit'),
                      color: AppColors.orangeColor,
                      onPressed: canEdit && offer.status == 0
                          ? () => onEdit(offer)
                          : null,
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      tooltip: _t('حذف', 'Delete'),
                      color: AppColors.darkorangeColor,
                      onPressed: canEdit && offer.status == 0
                          ? () => onDelete(offer)
                          : null,
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyRequests extends StatelessWidget {
  const _EmptyRequests({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.lightGreyColor,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(color: AppColors.darkGreyColor)),
        ],
      ),
    );
  }
}
