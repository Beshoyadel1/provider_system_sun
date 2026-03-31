import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/general/services/get_services_model/get_services_repository.dart';
import 'package:sun_web_system/core/api_functions/general/services/get_services_model/service_setting_model.dart';
import 'package:sun_web_system/features/service_settings/logic/cubit/service_settings_cubit/service_settings_state.dart';
import 'package:sun_web_system/features/service_settings/logic/service_settings_helper/service_settings_helper.dart';

class ServiceSettingsCubit extends Cubit<ServiceSettingsState> {
  ServiceSettingsCubit() : super(ServiceSettingsInitial());

  static ServiceSettingsCubit get(context) => BlocProvider.of(context);

  List<ServiceSettingModel> allServices = [];
  int currentParentId = 0;

  Future<void> getServices({required int parentId}) async {
    emit(ServiceSettingsLoading());

    try {
      currentParentId = parentId;

      if (allServices.isEmpty) {
        allServices = await getServicesFunction();
      }

      final filtered = ServiceSettingsHelper.filterByParentId(
        services: allServices,
        parentId: parentId,
      );

      emit(ServiceSettingsSuccess(filtered));
    } catch (e) {
      emit(ServiceSettingsError(e.toString()));
    }
  }
}