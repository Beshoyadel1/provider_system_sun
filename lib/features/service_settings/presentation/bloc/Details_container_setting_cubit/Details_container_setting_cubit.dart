import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/Details_container_setting_cubit/Details_container_setting_state.dart';


class DetailsContainerSettingCubit extends Cubit<DetailsContainerSettingState> {
  DetailsContainerSettingCubit() : super(DetailsContainerSettingState());

  void toggle() => emit(state.copyWith(isExpanded: !state.isExpanded));

  void collapse() => emit(state.copyWith(isExpanded: false));

  void selectOption(int value) =>
      emit(state.copyWith(selectedOption: value));
}