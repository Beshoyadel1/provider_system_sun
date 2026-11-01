import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/pages_widgets/general_widgets/app_filter_dialog.dart';
import 'package:sun_web_system/core/theming/colors.dart';
import '../../../service_settings/data/datasource/get_services_datasource/get_services_repository.dart';
import '../../../service_settings/data/model/get_services_model/service_setting_model.dart';
import '../cubit/service_requests_cubit.dart';
import '../cubit/service_requests_state.dart';

class ServiceRequestServerFilter extends StatelessWidget {
  const ServiceRequestServerFilter({super.key, this.servicesLoader});
  final Future<List<ServiceSettingModel>> Function()? servicesLoader;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ServiceRequestsCubit, ServiceRequestsState>(
          builder: (context, state) {
        final cubit = context.read<ServiceRequestsCubit>();
        return AppFilterButton(
          key: const Key('service-request-filter-button'),
          activeCount: cubit.selectedServiceIds.isEmpty ? 0 : 1,
          onPressed: () async {
            final selected = await showDialog<int>(
                context: context,
                builder: (_) => _ServicesFilterDialog(
                    selected: cubit.selectedServiceIds.firstOrNull ?? 0,
                    loader: servicesLoader ?? getServicesFunction));
            if (!context.mounted || cubit.isClosed || selected == null) return;
            if (selected == (cubit.selectedServiceIds.firstOrNull ?? 0)) return;
            await cubit.selectServices(selected == 0 ? [] : [selected]);
          },
        );
      });
}

class _ServicesFilterDialog extends StatefulWidget {
  const _ServicesFilterDialog({required this.selected, required this.loader});
  final int selected;
  final Future<List<ServiceSettingModel>> Function() loader;
  @override
  State<_ServicesFilterDialog> createState() => _ServicesFilterDialogState();
}

class _ServicesFilterDialogState extends State<_ServicesFilterDialog> {
  late int _selected = widget.selected;
  late Future<List<ServiceSettingModel>> _services;
  @override
  void initState() {
    super.initState();
    _services = widget.loader();
  }

  @override
  Widget build(BuildContext context) {
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    return AppFilterDialog(
      title: ar ? 'تصفية طلبات عروض الأسعار' : 'Filter service requests',
      onReset: () => setState(() => _selected = 0),
      onApply: () => Navigator.pop(context, _selected),
      child: FutureBuilder<List<ServiceSettingModel>>(
          future: _services,
          builder: (context, snapshot) {
            final services = {
              for (final item in snapshot.data ?? <ServiceSettingModel>[])
                if ((item.id ?? 0) > 0) item.id!: item
            };
            return Column(mainAxisSize: MainAxisSize.min, children: [
              AppFilterDropdown(
                  label: ar ? 'الخدمة' : 'Service',
                  value: _selected,
                  items: {
                    0: ar ? 'كل الخدمات' : 'All services',
                    if (_selected > 0 && !services.containsKey(_selected))
                      _selected: '#$_selected',
                    for (final item in services.entries)
                      item.key: (ar ? item.value.name : item.value.latinName) ??
                          item.value.name ??
                          '#${item.key}',
                  },
                  onChanged: snapshot.hasData
                      ? (id) => setState(() => _selected = id ?? 0)
                      : null),
              if (snapshot.connectionState != ConnectionState.done)
                const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child:
                        LinearProgressIndicator(color: AppColors.orangeColor)),
              if (snapshot.hasError)
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                        onPressed: () =>
                            setState(() => _services = widget.loader()),
                        icon: const Icon(Icons.refresh),
                        label: Text(
                            ar ? 'إعادة تحميل الخدمات' : 'Reload services'))),
            ]);
          }),
    );
  }
}
