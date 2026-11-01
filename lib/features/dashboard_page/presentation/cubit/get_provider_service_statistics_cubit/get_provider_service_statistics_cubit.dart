import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import '../../../data/datasource/get_provider_service_statistics_data_source/get_provider_service_statistics_repository.dart';
import '../../../data/datasource/dashboard_service_chart_repository.dart';
import '../../../data/model/dashboard_service.dart';
import '../../../data/request/get_provider_service_statistics_request/get_provider_service_statistics_request.dart';
import 'get_provider_service_statistics_state.dart';

class GetProviderServiceStatisticsCubit
    extends Cubit<GetProviderServiceStatisticsState> {
  GetProviderServiceStatisticsCubit()
      : super(GetProviderServiceStatisticsInitial());
  static GetProviderServiceStatisticsCubit get(context) =>
      BlocProvider.of(context);
  int _revision = 0;

  Future<void> getProviderServiceStatistics(
      {int? providerId,
      int? branchId,
      String? startDate,
      String? endDate}) async {
    if (isClosed) return;
    final revision = ++_revision;
    emit(GetProviderServiceStatisticsLoading());
    try {
      final id = providerId ?? (await AuthLocalStorage.getUser())?.userid;
      if (isClosed || revision != _revision) return;
      if (id == null || id <= 0) throw Exception(AppLanguageKeys.userNotFound);
      final request = GetProviderServiceStatisticsRequest(
          providerId: id,
          branchId: branchId,
          startDate: startDate,
          endDate: endDate);
      final data = await getProviderServiceStatisticsFunction(request: request);
      if (isClosed || revision != _revision) return;
      if (data == null) throw Exception(AppLanguageKeys.errorLoadingData);
      emit(GetProviderServiceStatisticsSuccess(data, charts: {
        for (final service in DashboardService.all)
          service.id: const ServiceChartState(loading: true),
      }));
      // Keep each plot independent: a failed service must not hide the summary.
      await Future.wait(DashboardService.all.map((service) async {
        ServiceChartState chart;
        try {
          chart = ServiceChartState(
              points: await getDashboardServiceChart(
                  serviceId: service.id, request: request));
        } catch (_) {
          chart = const ServiceChartState(failed: true);
        }
        if (isClosed || revision != _revision) return;
        final current = state;
        if (current is GetProviderServiceStatisticsSuccess) {
          emit(GetProviderServiceStatisticsSuccess(data,
              charts: {...current.charts, service.id: chart}));
        }
      }));
    } catch (_) {
      if (!isClosed && revision == _revision) {
        emit(GetProviderServiceStatisticsError(
            AppLanguageKeys.errorLoadingData));
      }
    }
  }
}
