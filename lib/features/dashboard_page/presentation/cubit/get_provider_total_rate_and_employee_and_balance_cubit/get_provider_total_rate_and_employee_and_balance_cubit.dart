import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import '../../../data/datasource/get_provider_total_rate_and_employee_and_balance_datasource/get_provider_total_rate_and_employee_and_balance_repository.dart';
import '../../../data/request/get_provider_total_rate_and_employee_and_balance_request/get_provider_total_rate_and_employee_and_balance_request.dart';
import 'get_provider_total_rate_and_employee_and_balance_state.dart';

class GetProviderTotalRateAndEmployeeAndBalanceCubit
    extends Cubit<GetProviderTotalRateAndEmployeeAndBalanceState> {
  GetProviderTotalRateAndEmployeeAndBalanceCubit()
      : super(GetProviderTotalRateAndEmployeeAndBalanceInitial());
  static GetProviderTotalRateAndEmployeeAndBalanceCubit get(context) =>
      BlocProvider.of(context);
  int _revision = 0;

  Future<void> getProviderTotalRateAndEmployeeAndBalance(
      {int? providerId, int? branchId}) async {
    if (isClosed) return;
    final revision = ++_revision;
    emit(GetProviderTotalRateAndEmployeeAndBalanceLoading());
    try {
      final id = providerId ?? (await AuthLocalStorage.getUser())?.userid;
      if (isClosed || revision != _revision) return;
      if (id == null || id <= 0) throw Exception(AppLanguageKeys.userNotFound);
      final result = await getProviderTotalRateAndEmployeeAndBalanceFunction(
          request: GetProviderTotalRateAndEmployeeAndBalanceRequest(
              providerId: id, branchId: branchId));
      if (isClosed || revision != _revision) return;
      if (result == null) throw Exception(AppLanguageKeys.errorLoadingData);
      emit(GetProviderTotalRateAndEmployeeAndBalanceSuccess(result));
    } catch (_) {
      if (!isClosed && revision == _revision) {
        emit(GetProviderTotalRateAndEmployeeAndBalanceError(
            AppLanguageKeys.errorLoadingData));
      }
    }
  }
}
