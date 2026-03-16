import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/order/get_provider_orders_model/get_provider_orders_repository.dart';
import 'package:sun_web_system/core/api_functions/order/get_provider_orders_model/get_provider_orders_request.dart';
import 'package:sun_web_system/core/api_functions/user/login_model/login_repository.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_cubit.dart';

class GetProviderInternalOrderCubit
    extends Cubit<GetProviderInternalOrderState> {

  GetProviderInternalOrderCubit()
      : super(GetProviderInternalOrderInitial());

  Future<void> loadInternalOrders({
     int? orderType,
     int? serviceId,
  }) async {

    emit(GetProviderInternalOrderLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null) {
        emit(const GetProviderInternalOrderError("User not found"));
        return;
      }

      final response = await getProviderOrdersFunction(
        getProviderOrdersRequest: GetProviderOrdersRequest(
          providerId: user.userid,
          employeeId: 0,
          pageNumber: 1,
          orderType: orderType,
          serviceId: serviceId,
        ),
      );

      emit(GetProviderInternalOrderSuccess(response.data ?? []));
    } catch (e) {
      emit(GetProviderInternalOrderError(e.toString()));
    }
  }
}