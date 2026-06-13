import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/get_services_datasource/get_services_repository.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_services_model/service_setting_model.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/cubit/service_settings_cubit/service_settings_state.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/service_settings_helper/service_settings_helper.dart';

class ServiceSettingsCubit extends Cubit<ServiceSettingsState> {
  ServiceSettingsCubit() : super(ServiceSettingsInitial());

  static ServiceSettingsCubit get(context) => BlocProvider.of(context);

  List<ServiceSettingModel> allServices = [];

  List<ServiceSettingModel> allMainServices = [];

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
  Future<void> getMainServices() async {
    emit(ServiceSettingsLoading());

    try {
      if (allServices.isEmpty) {
        allServices = await getServicesFunction();
      }

      final mainServices = allServices.where((e) {
        return (e.parentId ?? 0) == 0 &&
            (e.id ?? 0) != 4;
      }).toList();

      allMainServices=mainServices;
      emit(ServiceSettingsSuccess(mainServices));
    } catch (e) {
      emit(ServiceSettingsError(e.toString()));
    }
  }
  
  Future<void> getChildServices() async {
    emit(ServiceSettingsLoading());

    try {
      if (allServices.isEmpty) {
        allServices = await getServicesFunction();
      }

      final childServices = allServices
          .where((e) => (e.parentId ?? 0) != 0)
          .toList();


      emit(ServiceSettingsSuccess(childServices));
    } catch (e) {
      emit(ServiceSettingsError(e.toString()));
    }
  }
}