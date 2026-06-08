import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/select_category_add_Spare_Parts_cubit/select_category_add_Spare_Parts_state.dart';

class SelectCategoryAddSparePartsCubit
    extends Cubit<SelectCategoryAddSparePartsState> {
  SelectCategoryAddSparePartsCubit()
      : super(const SelectCategoryAddSparePartsState(selectedOption: 0));

  void changeOption(int value) {
    emit(SelectCategoryAddSparePartsState(selectedOption: value));
  }
}
