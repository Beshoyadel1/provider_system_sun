import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/create_service_package_datasource/create_service_package_repository.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_service_package_model/create_service_package_request.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/delete_service_package_datasource/delete_service_package_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/delete_service_package_request/delete_service_package_request.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/get_provider_service_packages_datasource/get_provider_service_packages_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/get_provider_service_packages_request/get_provider_service_packages_request.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/update_service_package_datasource/update_service_package_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/update_service_package_request/update_service_package_request.dart';
import 'package:sun_web_system/features/service_settings/data/model/get_provider_service_packages_model/provider_service_packages_model.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/provider_packages_cubit/provider_packages_state.dart';

typedef PackagesLoader = Future<List<ProviderServicePackagesModel>> Function(
    {required GetProviderServicePackagesRequest request});
typedef PackageCreator = Future<void> Function(
    {required CreateServicePackageRequest request});
typedef PackageUpdater = Future<void> Function(
    {required UpdateServicePackageRequest updateServicePackageRequest});

class ProviderPackagesCubit extends Cubit<ProviderPackagesState> {
  ProviderPackagesCubit({
    Future<int> Function()? providerIdLoader,
    PackagesLoader? packagesLoader,
    PackageCreator? packageCreator,
    PackageUpdater? packageUpdater,
  })  : _providerIdLoader = providerIdLoader,
        _packagesLoader = packagesLoader ?? getProviderServicePackagesFunction,
        _packageCreator = packageCreator ?? createServicePackageFunction,
        _packageUpdater = packageUpdater ?? updateServicePackageFunction,
        super(ProviderPackagesInitial());

  final Future<int> Function()? _providerIdLoader;
  final PackagesLoader _packagesLoader;
  final PackageCreator _packageCreator;
  final PackageUpdater _packageUpdater;
  int? selectedBranchId;
  int _requestVersion = 0;

  Future<int> _getProviderId() async {
    if (_providerIdLoader != null) return _providerIdLoader();
    final user = await AuthLocalStorage.getUser();
    final id = user?.userid;
    if (id == null || id <= 0) throw StateError('Provider not found');
    return id;
  }

  Future<void> selectBranch(int? branchId) async {
    selectedBranchId = branchId != null && branchId > 0 ? branchId : null;
    await getPackages();
  }

  /// 🔹 GET
  Future<void> getPackages() async {
    if (isClosed) return;
    final requestVersion = ++_requestVersion;
    emit(ProviderPackagesLoading());

    try {
      final providerId = await _getProviderId();

      if (isClosed || requestVersion != _requestVersion) return;
      final data = await _packagesLoader(
        request: GetProviderServicePackagesRequest(
          providerId: providerId,
          branchId: selectedBranchId,
        ),
      );

      if (isClosed || requestVersion != _requestVersion) return;
      emit(ProviderPackagesSuccess(data));
    } catch (e) {
      if (!isClosed && requestVersion == _requestVersion) {
        emit(ProviderPackagesError(e.toString()));
      }
    }
  }

  Future<void> deletePackage({required int id}) async {
    if (isClosed) return;
    emit(ProviderPackagesLoading());

    try {
      await deleteServicePackageFunction(
        deleteServicePackageRequest: DeleteServicePackageRequest(
          servicePackageId: id,
        ),
      );

      if (!isClosed) emit(ProviderPackagesDeleteSuccess()); // ✅
    } catch (e) {
      if (!isClosed) emit(ProviderPackagesError(e.toString()));
    }
  }

  /// 🔹 CREATE
  Future<void> createPackage({
    required String name,
    required String latinName,
    required String items,
    required num price,
    required int tax,
    required List<int> branchIds,
  }) async {
    if (isClosed) return;
    emit(ProviderPackagesLoading());

    try {
      final providerId = await _getProviderId();

      await _packageCreator(
        request: CreateServicePackageRequest(
          provId: providerId,
          branchIds: branchIds,
          name: name,
          latinName: latinName,
          items: [
            PackageItemRequest(
              packageId: 0,
              item: items,
              latinItem: items,
            ),
          ],
          taxId: tax,
          price: price,
          cost: 0,
          serviceIds: [6],
          supportedCars: [
            SupportedCarRequest(
              carBrandId: 1,
              carModelIds: [1, 2],
            ),
          ],
        ),
      );

      if (!isClosed) emit(ProviderPackagesCreateSuccess());
    } catch (e) {
      if (!isClosed) emit(ProviderPackagesError(e.toString()));
    }
  }

  /// 🔹 UPDATE
  Future<void> updatePackage({
    required int id,
    required String name,
    required String latinName,
    required String items,
    required num price,
    required int tax,
    required List<int> branchIds,
    List<int>? serviceIds,
    num? cost,
  }) async {
    if (isClosed) return;
    emit(ProviderPackagesLoading());

    try {
      final providerId = await _getProviderId();

      await _packageUpdater(
        updateServicePackageRequest: UpdateServicePackageRequest(
          id: id,
          provId: providerId,
          branchIds: branchIds,
          name: name,
          latinName: latinName,
          taxId: tax,
          price: price,
          cost: cost,
          items: [
            PackageItemRequest(
              packageId: id,
              item: items,
              latinItem: items,
            ),
          ],
          serviceIds: serviceIds,
        ),
      );

      if (!isClosed) emit(ProviderPackagesUpdateSuccess()); // ✅
    } catch (e) {
      if (!isClosed) emit(ProviderPackagesError(e.toString()));
    }
  }
}
