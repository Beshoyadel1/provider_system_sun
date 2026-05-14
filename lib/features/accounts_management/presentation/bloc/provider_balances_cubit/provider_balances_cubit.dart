import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/accounts_management/data/datasource/get_provider_balance_details_datasource/get_provider_balance_details_repository.dart';
import 'package:sun_web_system/features/accounts_management/data/model/get_provider_balance_details_model/get_provider_balance_details_request.dart';
import 'package:sun_web_system/features/accounts_management/presentation/bloc/provider_balances_cubit/provider_balances_state.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';


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