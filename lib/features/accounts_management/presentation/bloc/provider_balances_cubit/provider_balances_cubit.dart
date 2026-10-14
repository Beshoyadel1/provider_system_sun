import 'package:sun_web_system/core/language/language_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import '../../../../../../../features/accounts_management/data/datasource/get_provider_balance_details_datasource/get_provider_balance_details_repository.dart';
import '../../../../../../../features/accounts_management/data/request/get_provider_balance_details_request/get_provider_balance_details_request.dart';
import '../../../../../../../features/accounts_management/presentation/bloc/provider_balances_cubit/provider_balances_state.dart';
import '../../../../../../../features/auth_page/data/datasource/login_datasource/login_repository.dart';


class ProviderBalanceCubit extends Cubit<ProviderBalanceState> {
  ProviderBalanceCubit() : super(ProviderBalanceInitial());

  Future<void> getBalanceDetails() async {
    emit(ProviderBalanceLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null) {
        emit(ProviderBalanceError(AppLanguageKeys.userNotFound));
        return;
      }

      final request = GetProviderBalanceDetailsRequest(
        providerId: user.userid??5,
      );

      final data = await getProviderBalanceDetailsFunction(
        request: request,
      );

      if (data == null) {
        emit(ProviderBalanceError(AppLanguageKeys.noDataAvailable));
        return;
      }

      emit(ProviderBalanceSuccess(data));

    } catch (e) {
      emit(ProviderBalanceError(e.toString()));
    }
  }
}