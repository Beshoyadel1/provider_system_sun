import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/payments_and_wallet/get_provider_balance_details_model/get_provider_balance_details_repository.dart';
import 'package:sun_web_system/core/api_functions/payments_and_wallet/get_provider_balance_details_model/get_provider_balance_details_request.dart';
import 'package:sun_web_system/core/api_functions/user/login_model/login_repository.dart';
import 'package:sun_web_system/features/accounts_management/logic/provider_balances_cubit/provider_balances_state.dart';


class ProviderBalanceCubit extends Cubit<ProviderBalanceState> {
  ProviderBalanceCubit() : super(ProviderBalanceInitial());

  Future<void> getBalanceDetails() async {
    emit(ProviderBalanceLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null) {
        emit(ProviderBalanceError("User not found"));
        return;
      }

      final request = GetProviderBalanceDetailsRequest(
        providerId: user.userid??5,
      );

      final data = await getProviderBalanceDetailsFunction(
        request: request,
      );

      if (data == null) {
        emit(ProviderBalanceError("No data"));
        return;
      }

      emit(ProviderBalanceSuccess(data));

    } catch (e) {
      emit(ProviderBalanceError(e.toString()));
    }
  }
}