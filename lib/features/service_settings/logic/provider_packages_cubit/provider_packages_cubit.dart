import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_service_package_model/car_model_create_service_package_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_service_package_model/create_service_package_repository.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_service_package_model/create_service_package_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/delete_prov_service_model/delete_prov_service_repository.dart';
import 'package:sun_web_system/core/api_functions/provider_management/delete_prov_service_model/delete_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/delete_service_package_model/delete_service_package_repository.dart';
import 'package:sun_web_system/core/api_functions/provider_management/delete_service_package_model/delete_service_package_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/get_provider_service_packages_model/get_provider_service_packages_repository.dart';
import 'package:sun_web_system/core/api_functions/provider_management/get_provider_service_packages_model/get_provider_service_packages_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/update_prov_service_model/update_prov_service_repository.dart';
import 'package:sun_web_system/core/api_functions/provider_management/update_prov_service_model/update_prov_service_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/update_service_package_model/update_service_package_repository.dart';
import 'package:sun_web_system/core/api_functions/provider_management/update_service_package_model/update_service_package_request.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_state.dart';

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
          items: items,
          taxId: tax,
          price: price,
          serviceIds: [6],
          cars: [
            CarModelCreateServicePackageRequest(
              carBrandId: 1,
              carModelIds: [1, 2],
            ),
          ],
        ),
      );

      emit(ProviderPackagesCreateSuccess()); // ✅
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
          items: items,
          serviceIds: [],
          cars: [],
        ),
      );

      emit(ProviderPackagesUpdateSuccess()); // ✅
    } catch (e) {
      emit(ProviderPackagesError(e.toString()));
    }
  }
}