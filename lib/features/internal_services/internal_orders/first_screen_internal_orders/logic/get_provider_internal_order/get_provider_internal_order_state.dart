import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/order/get_provider_orders_model/get_provider_orders_repository.dart';
import 'package:sun_web_system/core/api_functions/order/get_provider_orders_model/get_provider_orders_request.dart';
import 'package:sun_web_system/core/api_functions/user/login_model/login_repository.dart';
import 'package:sun_web_system/features/internal_services/internal_orders/first_screen_internal_orders/logic/get_provider_internal_order/get_provider_internal_order_cubit.dart';
import 'get_provider_internal_order_state.dart';

class GetProviderInternalOrderCubit
    extends Cubit<GetProviderInternalOrderState> {

  GetProviderInternalOrderCubit()
      : super(GetProviderInternalOrderInitial());

  Future<void> loadInternalOrders({
    int? orderType,
    int? serviceId,
    int? pageNumber,
  }) async {

    if (!isClosed) {
      emit(GetProviderInternalOrderLoading());
    }

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null) {
        if (!isClosed) {
          emit(const GetProviderInternalOrderError("User not found"));
        }
        return;
      }

      final response = await getProviderOrdersFunction(

        getProviderOrdersRequest: GetProviderOrdersRequest(
          providerId: user.userid,
          employeeId: 0,
          pageNumber: pageNumber ?? 1,
          orderType: orderType,
          serviceId: serviceId,
        ),
      );
      print(user.userid);

      if (!isClosed) {
        emit(
          GetProviderInternalOrderSuccess(
            response.data ?? [],
            currentPage: response.currentPage ?? 1,
            pageCount: response.pageCount ?? 1,
            totalCount: response.totalCount ?? 1,
          ),
        );
      }

    } catch (e) {
      if (!isClosed) {
        emit(GetProviderInternalOrderError(e.toString()));
      }
    }
  }
}