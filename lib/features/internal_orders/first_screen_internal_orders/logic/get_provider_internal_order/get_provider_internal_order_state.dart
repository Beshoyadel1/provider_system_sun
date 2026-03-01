import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/order/get_provider_orders_model/get_provider_orders_repository.dart';
import 'package:sun_web_system/core/api_functions/order/get_provider_orders_model/get_provider_orders_request.dart';
import 'package:sun_web_system/core/api_functions/order/get_provider_orders_model/get_provider_orders_response.dart';
import 'package:sun_web_system/features/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_cubit.dart';


class GetProviderInternalOrderCubit
    extends Cubit<GetProviderInternalOrderState> {

  GetProviderInternalOrderCubit()
      : super(GetProviderInternalOrderInitial());

  Future<void> getProviderInternalOrders({
    required int providerId,
    required int serviceId,
  }) async {

    emit(GetProviderInternalOrderLoading());

    try {
      final GetProviderOrdersResponse response =
      await getProviderOrdersFunction(
        getProviderOrdersRequest: GetProviderOrdersRequest(
          providerId: providerId,
          employeeId: 0,
          pageNumber: 1,
          orderType: 0,
          serviceId: serviceId,
        ),
      );

      emit(
        GetProviderInternalOrderSuccess(
          response.data ?? [],
        ),
      );
    } catch (e) {
      emit(
        GetProviderInternalOrderError(
          e.toString(),
        ),
      );
    }
  }
}