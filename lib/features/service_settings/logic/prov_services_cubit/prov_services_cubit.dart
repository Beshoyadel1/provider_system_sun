import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/api_functions/provider_management/get_prov_services_model/get_prov_services_repository.dart';
import '../../../../core/api_functions/provider_management/get_prov_services_model/get_prov_services_request.dart';
import '../../../../core/api_functions/provider_management/get_prov_services_model/get_prov_services_response.dart';
import '../../../../core/api_functions/provider_management/update_prov_service_model/update_prov_service_repository.dart';
import '../../../../core/api_functions/provider_management/update_prov_service_model/update_prov_service_request.dart';
import '../../../../core/api_functions/provider_management/delete_prov_service_model/delete_prov_service_repository.dart';
import '../../../../core/api_functions/provider_management/delete_prov_service_model/delete_prov_service_request.dart';
import '../../../auth_page/data/datasource/login_datasource/login_repository.dart';
import '../../../../core/api/dio_function/failures.dart';
import '../../../../features/service_settings/logic/prov_services_cubit/prov_services_state.dart';

class ProvServicesCubit extends Cubit<ProvServicesState> {
  ProvServicesCubit() : super(ProvServicesInitial());

  List<GetProvServicesResponse> response = [];

  Future<int> _getProviderId() async {
    final user = await AuthLocalStorage.getUser();
    return user?.userid ?? 0;
  }

  Future<void> getProvServices({
    required int serviceId,
  }) async {
    emit(ProvServicesLoading());

    try {
      final providerId = await _getProviderId();

      final result = await getProvServicesFunction(
        getProvServicesRequest: GetProvServicesRequest(
          providerId: providerId,
          serviceId: serviceId,
        ),
      );

      response = result;

      emit(ProvServicesSuccess(result));
    } catch (e, stack) {
      print("❌ ERROR: $e");
      print("📍 STACK: $stack");

      emit(ProvServicesError(e.toString()));
    }
  }

  Future<void> deleteProvService({
    required int provServiceId,
  }) async {
    try {
      await deleteProvServiceFunction(
        deleteProvServiceRequest:
        DeleteProvServiceRequest(provServiceId: provServiceId),
      );

      emit(ProvServiceDeleteSuccess());

      if (response.isNotEmpty) {
        await getProvServices(
          serviceId: response.first.provService.serviceid,
        );
      }
    } catch (e) {
      emit(ProvServicesError(e.toString()));
    }
  }
  Future<void> updateProvService({
    required UpdateProvServiceRequest request,
  }) async {
    emit(ProvServicesLoading());

    try {
      await updateProvServiceFunction(
        updateProvServiceRequest: request,
      );

      emit(ProvServiceUpdateSuccess());

      if (response.isNotEmpty) {
        await getProvServices(
          serviceId: response.first.provService.serviceid,
        );
      }
    } catch (e) {
      emit(ProvServicesError(e.toString()));
    }
  }
}