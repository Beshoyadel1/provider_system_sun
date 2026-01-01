import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/dashboard/Admin/internal_orders/first_screen_internal_orders/logic/loading_dashboard_state.dart';

class InternalOrdersCubit extends Cubit<InternalOrdersState> {
  InternalOrdersCubit() : super(InternalOrdersState());

  void startLoading() async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(isLoading: false, isLoaded: true));
  }
}