import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import '../../../data/datasource/get_provider_orders_sales_datasource/get_provider_orders_sales_repository.dart';
import '../../../data/request/get_provider_orders_sales_request/get_provider_orders_sales_request.dart';
import 'get_provider_orders_sales_state.dart';

class GetProviderOrdersSalesCubit extends Cubit<GetProviderOrdersSalesState> {
  GetProviderOrdersSalesCubit() : super(GetProviderOrdersSalesInitial());
  static GetProviderOrdersSalesCubit get(context) => BlocProvider.of(context);
  int _revision = 0;

  Future<void> getProviderOrdersSales(
      {int? providerId,
      int? branchId,
      String? startDate,
      String? endDate}) async {
    if (isClosed) return;
    final revision = ++_revision;
    emit(GetProviderOrdersSalesLoading());
    try {
      final id = providerId ?? (await AuthLocalStorage.getUser())?.userid;
      if (isClosed || revision != _revision) return;
      if (id == null || id <= 0) throw Exception(AppLanguageKeys.userNotFound);
      final result = await getProviderOrdersSalesFunction(
          request: GetProviderOrdersSalesRequest(
              providerId: id,
              branchId: branchId,
              startDate: startDate,
              endDate: endDate));
      if (isClosed || revision != _revision) return;
      if (result == null) throw Exception(AppLanguageKeys.errorLoadingData);
      emit(GetProviderOrdersSalesSuccess(result));
    } catch (_) {
      if (!isClosed && revision == _revision) {
        emit(GetProviderOrdersSalesError(AppLanguageKeys.errorLoadingData));
      }
    }
  }
}
