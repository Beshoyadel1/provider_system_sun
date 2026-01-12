import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../features/service_settings/car_spare_parts_in_service_settings/sub/add_spare_parts_in_service_settings/logic/select_category_add_Spare_Parts_state.dart';

class SelectCategoryAddSparePartsCubit
    extends Cubit<SelectCategoryAddSparePartsState> {
  SelectCategoryAddSparePartsCubit()
      : super(const SelectCategoryAddSparePartsState(selectedOption: 0));

  void changeOption(int value) {
    emit(SelectCategoryAddSparePartsState(selectedOption: value));
  }
}
