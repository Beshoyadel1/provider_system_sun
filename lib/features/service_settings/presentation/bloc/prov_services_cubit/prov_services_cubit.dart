import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/prov_services_cubit/prov_services_state.dart';
import '../../../data/datasource/get_prov_services_datasource/get_prov_services_repository.dart';
import '../../../data/request/get_prov_services_request/get_prov_services_request.dart';
import '../../../data/response/get_prov_services_response/get_prov_services_response.dart';
import '../../../data/datasource/update_prov_service_datasource/update_prov_service_repository.dart';
import '../../../data/request/update_prov_service_request/update_prov_service_request.dart';
import '../../../data/datasource/delete_prov_service_datasource/delete_prov_service_repository.dart';
import '../../../data/request/delete_prov_service_request/delete_prov_service_request.dart';

typedef ProviderIdLoader = Future<int> Function();
typedef ProvServicesLoader = Future<List<GetProvServicesResponse>> Function({
  required GetProvServicesRequest getProvServicesRequest,
});

class ProvServicesCubit extends Cubit<ProvServicesState> {
  ProvServicesCubit({
    ProviderIdLoader? providerIdLoader,
    ProvServicesLoader? provServicesLoader,
  })  : _providerIdLoader = providerIdLoader,
        _provServicesLoader = provServicesLoader ?? getProvServicesFunction,
        super(ProvServicesInitial());

  final ProviderIdLoader? _providerIdLoader;
  final ProvServicesLoader _provServicesLoader;

  List<GetProvServicesResponse> response = [];

  Future<int> _getProviderId() async {
    if (_providerIdLoader != null) {
      return _providerIdLoader();
    }

    final user = await AuthLocalStorage.getUser();
    return user?.userid ?? 0;
  }

  void _emitIfOpen(ProvServicesState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  Future<void> getProvServices({
    required int serviceId,
  }) async {
    if (isClosed) return;

    _emitIfOpen(ProvServicesLoading());

    try {
      final providerId = await _getProviderId();

      final result = await _provServicesLoader(
        getProvServicesRequest: GetProvServicesRequest(
          providerId: providerId,
          serviceId: serviceId,
        ),
      );

      if (isClosed) return;

      response = result;

      _emitIfOpen(ProvServicesSuccess(result));
    } catch (e, stack) {
      print("❌ ERROR: $e");
      print("📍 STACK: $stack");

      _emitIfOpen(ProvServicesError(e.toString()));
    }
  }

  Future<void> deleteProvService({
    required int provServiceId,
  }) async {
    if (isClosed) return;

    try {
      await deleteProvServiceFunction(
        deleteProvServiceRequest:
            DeleteProvServiceRequest(provServiceId: provServiceId),
      );

      if (isClosed) return;

      _emitIfOpen(ProvServiceDeleteSuccess());

      if (response.isNotEmpty) {
        await getProvServices(
          serviceId: response.first.provService.serviceid,
        );
      }
    } catch (e) {
      _emitIfOpen(ProvServicesError(e.toString()));
    }
  }

  Future<void> updateProvService({
    required UpdateProvServiceRequest request,
  }) async {
    if (isClosed) return;

    _emitIfOpen(ProvServicesLoading());

    try {
      await updateProvServiceFunction(
        updateProvServiceRequest: request,
      );

      if (isClosed) return;

      _emitIfOpen(ProvServiceUpdateSuccess());

      if (response.isNotEmpty) {
        await getProvServices(
          serviceId: response.first.provService.serviceid,
        );
      }
    } catch (e) {
      _emitIfOpen(ProvServicesError(e.toString()));
    }
  }
}
