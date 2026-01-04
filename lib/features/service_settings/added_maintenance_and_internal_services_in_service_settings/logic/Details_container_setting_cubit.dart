import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/service_settings/added_maintenance_and_internal_services_in_service_settings/logic/Details_container_setting_state.dart';


class DetailsContainerSettingCubit extends Cubit<DetailsContainerSettingState> {
  DetailsContainerSettingCubit() : super(DetailsContainerSettingState());

  void toggle() => emit(state.copyWith(isExpanded: !state.isExpanded));

  void selectOption(int value) =>
      emit(state.copyWith(selectedOption: value));
}
