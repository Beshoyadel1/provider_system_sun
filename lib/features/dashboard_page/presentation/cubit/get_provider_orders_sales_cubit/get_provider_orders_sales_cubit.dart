import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/dashboard_page/data/datasource/get_provider_orders_sales_datasource/get_provider_orders_sales_repository.dart';
import 'package:sun_web_system/features/dashboard_page/data/request/get_provider_orders_sales_request/get_provider_orders_sales_request.dart';
import 'package:sun_web_system/features/dashboard_page/presentation/cubit/get_provider_orders_sales_cubit/get_provider_orders_sales_state.dart';

class GetProviderOrdersSalesCubit
    extends Cubit<GetProviderOrdersSalesState> {
  GetProviderOrdersSalesCubit()
      : super(GetProviderOrdersSalesInitial());

  static GetProviderOrdersSalesCubit get(context) =>
      BlocProvider.of(context);

  Future<void> getProviderOrdersSales() async {
    if (isClosed) return;

    emit(GetProviderOrdersSalesLoading());

    try {
      // =========================================================
      // GET LOCAL USER
      // =========================================================

      final user = await AuthLocalStorage.getUser();

      if (isClosed) return;

      if (user == null) {
        emit(
          GetProviderOrdersSalesError(
            "User not found",
          ),
        );
        return;
      }

      // =========================================================
      // API
      // =========================================================

      final result = await getProviderOrdersSalesFunction(
        request: GetProviderOrdersSalesRequest(
          providerId: user.userid ?? 0,
        ),
      );

      if (isClosed) return;

      // =========================================================
      // SUCCESS
      // =========================================================

      if (result != null) {
        emit(
          GetProviderOrdersSalesSuccess(
            result,
          ),
        );
        return;
      }

      // =========================================================
      // ERROR
      // =========================================================

      emit(
        GetProviderOrdersSalesError(
          "Error loading data",
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        GetProviderOrdersSalesError(
          e.toString(),
        ),
      );
    }
  }
}