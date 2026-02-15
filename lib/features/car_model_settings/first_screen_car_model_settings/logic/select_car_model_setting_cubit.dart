import 'package:flutter_bloc/flutter_bloc.dart';
import 'select_car_model_setting_state.dart';

class SelectCarModelSettingCubit extends Cubit<SelectCarModelSettingState> {
  SelectCarModelSettingCubit() : super(SelectCarModelSettingState(-1));

  void selectModel(int index) {
    if (state.selectedIndex == index) {
      emit(SelectCarModelSettingState(-1));
    } else {
      emit(SelectCarModelSettingState(index));
    }
  }
}
