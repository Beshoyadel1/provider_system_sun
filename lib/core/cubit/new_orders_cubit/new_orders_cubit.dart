import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/Internal_services_page/model/new_order_steps_model/new_order_steps_model.dart';
import 'new_orders_state.dart';

class NewOrdersCubit extends Cubit<NewOrdersState> {
  NewOrdersCubit() : super(NewOrdersInitial());

  void showOrdersList() {
    emit(NewOrdersInitial());
  }

  void showOrderDetails() {
    emit(NewOrderDetails());
  }

  int selectedIndex = 0;

  void selectTab(int index) {
    for (int i = 0; i < steps.length; i++) {
      steps[i] = NewOrderStepsModel(
        title: steps[i].title,
        content: steps[i].content,
        isActive: i <= index,
        date: steps[i].date,
      );
    }

    selectedIndex = index;
    emit(ChangeIndexState());
  }
}
