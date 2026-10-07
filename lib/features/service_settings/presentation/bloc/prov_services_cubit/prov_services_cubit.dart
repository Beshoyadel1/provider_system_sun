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
typedef ProvServiceUpdater = Future<void> Function({
  required UpdateProvServiceRequest updateProvServiceRequest,
});

class ProvServicesCubit extends Cubit<ProvServicesState> {
  ProvServicesCubit({
    ProviderIdLoader? providerIdLoader,
    ProvServicesLoader? provServicesLoader,
    ProvServiceUpdater? provServiceUpdater,
  })  : _providerIdLoader = providerIdLoader,
        _provServicesLoader = provServicesLoader ?? getProvServicesFunction,
        _provServiceUpdater = provServiceUpdater ?? updateProvServiceFunction,
        super(ProvServicesInitial());

  final ProviderIdLoader? _providerIdLoader;
  final ProvServicesLoader _provServicesLoader;
  final ProvServiceUpdater _provServiceUpdater;

  List<GetProvServicesResponse> response = [];
  int? selectedBranchId;
  int? _currentServiceId;
  int? _currentProviderId;
  int _requestVersion = 0;

  bool _matchesFilter(GetProvServicesResponse item) =>
      (_currentServiceId == null ||
          item.provService.serviceid == _currentServiceId) &&
      (_currentProviderId == null ||
          item.provService.provid == _currentProviderId) &&
      (selectedBranchId == null ||
          item.provService.branchIds.contains(selectedBranchId));

  Future<void> selectBranch({required int serviceId, int? branchId}) async {
    selectedBranchId = branchId != null && branchId > 0 ? branchId : null;
    await getProvServices(serviceId: serviceId);
  }

  final Map<int, GetProvServicesResponse> _locallyCreatedServices = {};

  Future<int> _getProviderId() async {
    if (_providerIdLoader != null) {
      return _providerIdLoader();
    }

    final user = await AuthLocalStorage.getUser();
    final id = user?.userid;
    if (id == null || id <= 0) throw StateError('Provider not found');
    return id;
  }

  void _emitIfOpen(ProvServicesState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  void addCreatedService(GetProvServicesResponse service) {
    if (isClosed) return;

    _locallyCreatedServices[service.provService.id] = service;
    if (!_matchesFilter(service)) return;

    final updatedServices = List<GetProvServicesResponse>.from(response);
    final existingIndex = updatedServices.indexWhere(
      (item) => item.provService.id == service.provService.id,
    );

    if (existingIndex == -1) {
      updatedServices.add(service);
    } else {
      updatedServices[existingIndex] = service;
    }

    response = updatedServices;
    _emitIfOpen(ProvServicesSuccess(List.unmodifiable(updatedServices)));
  }

  Future<void> getProvServices({
    required int serviceId,
  }) async {
    if (isClosed) return;

    final requestVersion = ++_requestVersion;
    _currentServiceId = serviceId;
    _emitIfOpen(ProvServicesLoading());

    try {
      final providerId = await _getProviderId();

      if (isClosed || requestVersion != _requestVersion) return;
      if (_currentProviderId != null && _currentProviderId != providerId) {
        _locallyCreatedServices.clear();
        response = [];
        selectedBranchId = null;
      }
      _currentProviderId = providerId;
      final result = await _provServicesLoader(
        getProvServicesRequest: GetProvServicesRequest(
          providerId: providerId,
          serviceId: serviceId,
          branchId: selectedBranchId,
        ),
      );

      if (isClosed || requestVersion != _requestVersion) return;

      final serverIds = result.map((item) => item.provService.id).toSet();
      _locallyCreatedServices.removeWhere((id, _) => serverIds.contains(id));

      response = [
        ...result,
        ..._locallyCreatedServices.values.where(_matchesFilter),
      ];

      _emitIfOpen(ProvServicesSuccess(List.unmodifiable(response)));
    } catch (e, stack) {
      print("❌ ERROR: $e");
      print("📍 STACK: $stack");

      if (requestVersion == _requestVersion) {
        _emitIfOpen(ProvServicesError(e.toString()));
      }
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

      _locallyCreatedServices.remove(provServiceId);
      _emitIfOpen(ProvServiceDeleteSuccess());

      if (_currentServiceId != null) {
        await getProvServices(
          serviceId: _currentServiceId!,
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
      await _provServiceUpdater(
        updateProvServiceRequest: request,
      );

      if (isClosed) return;

      final updatedServices = List<GetProvServicesResponse>.from(response);
      final updatedIndex = updatedServices.indexWhere(
        (item) => item.provService.id == request.id,
      );

      if (updatedIndex != -1) {
        final updatedService = _applyUpdateRequest(
          current: updatedServices[updatedIndex],
          request: request,
        );

        updatedServices[updatedIndex] = updatedService;

        if (_locallyCreatedServices
            .containsKey(updatedService.provService.id)) {
          _locallyCreatedServices[updatedService.provService.id] =
              updatedService;
        }
      }

      response = updatedServices.where(_matchesFilter).toList();
      _emitIfOpen(
        ProvServiceUpdateSuccess(List.unmodifiable(response)),
      );
    } catch (e) {
      _emitIfOpen(ProvServicesError(e.toString()));
    }
  }

  GetProvServicesResponse _applyUpdateRequest({
    required GetProvServicesResponse current,
    required UpdateProvServiceRequest request,
  }) {
    final provServiceId = request.id ?? current.provService.id;

    final updatedBrands = (request.brands ?? const []).map((brand) {
      int? requestedCarBrandId;
      for (final car in brand.cars) {
        if (car.carbrandid != null) {
          requestedCarBrandId = car.carbrandid;
          break;
        }
      }

      BrandItem? existingBrand;
      for (final candidate in current.brands) {
        final isSameRow = candidate.provServiceBrand.id == brand.id;
        final isSameBrand = candidate.provServiceBrand.brandid == brand.id ||
            candidate.provServiceBrand.brandid == requestedCarBrandId;

        if (isSameRow || isSameBrand) {
          existingBrand = candidate;
          break;
        }
      }

      final brandId = existingBrand?.provServiceBrand.brandid ??
          requestedCarBrandId ??
          brand.id ??
          0;

      final models = brand.cars.map((car) {
        ModelItem? existingModel;
        for (final candidate in existingBrand?.models ?? const <ModelItem>[]) {
          if (candidate.carbrandid == (car.carbrandid ?? brandId) &&
              candidate.carmodelid == car.carmodelid) {
            existingModel = candidate;
            break;
          }
        }

        return ModelItem(
          id: existingModel?.id ?? 0,
          provserviceid: provServiceId,
          carbrandid: car.carbrandid ?? brandId,
          carmodelid: car.carmodelid ?? 0,
          price: car.price ?? 0,
          cost: car.cost ?? 0,
        );
      }).toList();

      return BrandItem(
        provServiceBrand: ProvServiceBrand(
          id: existingBrand?.provServiceBrand.id ?? 0,
          provserviceid: provServiceId,
          brandid: brandId,
          unifiedprice: brand.unifiedprice,
          isunifiedprice: brand.isunifiedprice ?? false,
          cost: brand.cost,
        ),
        models: models,
      );
    }).toList();

    return GetProvServicesResponse(
      provService: ProvService(
        id: provServiceId,
        branchIds: request.branchIds ?? current.provService.branchIds,
        serviceid: request.serviceId ?? current.provService.serviceid,
        provid: request.provId ?? current.provService.provid,
        taxid: request.taxId ?? current.provService.taxid,
        name: request.name ?? current.provService.name,
        latinname: request.latinName ?? current.provService.latinname,
        unifiedprice: request.uniformprice ?? current.provService.unifiedprice,
        cost: request.cost ?? current.provService.cost,
        isunifiedprice:
            request.isuniformprice ?? current.provService.isunifiedprice,
      ),
      brands: updatedBrands,
    );
  }
}
