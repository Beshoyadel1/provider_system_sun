import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/dashboard_page/data/datasource/get_provider_service_statistics_data_source/get_provider_service_statistics_repository.dart';
import 'package:sun_web_system/features/dashboard_page/data/request/get_provider_service_statistics_request/get_provider_service_statistics_request.dart';
import 'package:sun_web_system/features/dashboard_page/presentation/cubit/get_provider_service_statistics_cubit/get_provider_service_statistics_state.dart';

class GetProviderServiceStatisticsCubit
    extends Cubit<GetProviderServiceStatisticsState> {
  GetProviderServiceStatisticsCubit()
      : super(GetProviderServiceStatisticsInitial());

  static GetProviderServiceStatisticsCubit get(context) =>
      BlocProvider.of(context);

  Future<void> getProviderServiceStatistics() async {
    if (isClosed) return;

    emit(GetProviderServiceStatisticsLoading());

    try {
      // =========================================================
      // GET LOCAL USER
      // =========================================================

      final user = await AuthLocalStorage.getUser();

      if (isClosed) return;

      if (user == null) {
        emit(
          GetProviderServiceStatisticsError(
            "User not found",
          ),
        );
        return;
      }

      // =========================================================
      // API
      // =========================================================

      final result = await getProviderServiceStatisticsFunction(
        request: GetProviderServiceStatisticsRequest(
          providerId: user.userid ?? 0,
        ),
      );

      if (isClosed) return;

      // =========================================================
      // SUCCESS
      // =========================================================

      if (result != null) {
        emit(
          GetProviderServiceStatisticsSuccess(
            result,
          ),
        );
        return;
      }

      // =========================================================
      // ERROR
      // =========================================================

      emit(
        GetProviderServiceStatisticsError(
          "Error loading data",
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        GetProviderServiceStatisticsError(
          e.toString(),
        ),
      );
    }
  }
}