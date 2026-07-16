import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/create_service_package_datasource/create_service_package_repository.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_service_package_model/car_model_create_service_package_request.dart';
import 'package:sun_web_system/features/service_settings/data/model/create_service_package_model/create_service_package_request.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/delete_service_package_datasource/delete_service_package_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/delete_service_package_request/delete_service_package_request.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/get_provider_service_packages_datasource/get_provider_service_packages_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/get_provider_service_packages_request/get_provider_service_packages_request.dart';
import 'package:sun_web_system/features/service_settings/data/datasource/update_service_package_datasource/update_service_package_repository.dart';
import 'package:sun_web_system/features/service_settings/data/request/update_service_package_request/update_service_package_request.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:sun_web_system/features/service_settings/presentation/bloc/provider_packages_cubit/provider_packages_state.dart';

class ProviderPackagesCubit extends Cubit<ProviderPackagesState> {
  ProviderPackagesCubit() : super(ProviderPackagesInitial());

  /// 🔹 GET
  Future<void> getPackages() async {
    emit(ProviderPackagesLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      final data = await getProviderServicePackagesFunction(
        request: GetProviderServicePackagesRequest(
          providerId: user?.userid ?? 5,
        ),
      );

      emit(ProviderPackagesSuccess(data));
    } catch (e) {
      emit(ProviderPackagesError(e.toString()));
    }
  }
  Future<void> deletePackage({required int id}) async {
    emit(ProviderPackagesLoading());

    try {
      await deleteServicePackageFunction(
        deleteServicePackageRequest: DeleteServicePackageRequest(
          servicePackageId: id,
        ),
      );

      emit(ProviderPackagesDeleteSuccess()); // ✅
    } catch (e) {
      emit(ProviderPackagesError(e.toString()));
    }
  }
  /// 🔹 CREATE
  Future<void> createPackage({
    required String name,
    required String latinName,
    required String items,
    required num price,
    required int tax,
  }) async {
    emit(ProviderPackagesLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      await createServicePackageFunction(
        request: CreateServicePackageRequest(
          provId: user?.userid ?? 5,
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

      emit(ProviderPackagesCreateSuccess());
    } catch (e) {
      emit(ProviderPackagesError(e.toString()));
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
  }) async {
    emit(ProviderPackagesLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      await updateServicePackageFunction(
        updateServicePackageRequest: UpdateServicePackageRequest(
          id: id,
          provId: user?.userid,
          name: name,
          latinName: latinName,
          taxId: tax,
          price: price,
          cost: 0,
          items: [
            PackageItemRequest(
              packageId: id,
              item: items,
              latinItem: items,
            ),
          ],
          serviceIds: [],
          supportedCars: [],
        ),
      );

      emit(ProviderPackagesUpdateSuccess()); // ✅
    } catch (e) {
      emit(ProviderPackagesError(e.toString()));
    }
  }
}