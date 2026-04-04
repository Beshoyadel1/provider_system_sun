import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_service_package_model/car_model_create_service_package_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_service_package_model/create_service_package_repository.dart';
import 'package:sun_web_system/core/api_functions/provider_management/create_service_package_model/create_service_package_request.dart';
import 'package:sun_web_system/core/api_functions/provider_management/get_provider_service_packages_model/get_provider_service_packages_repository.dart';
import 'package:sun_web_system/core/api_functions/provider_management/get_provider_service_packages_model/get_provider_service_packages_request.dart';
import 'package:sun_web_system/core/api_functions/user/login_model/login_repository.dart';
import 'package:sun_web_system/features/service_settings/logic/provider_packages_cubit/provider_packages_state.dart';

class ProviderPackagesCubit extends Cubit<ProviderPackagesState> {
  ProviderPackagesCubit() : super(ProviderPackagesInitial());

  Future<void> getPackages() async {
    emit(ProviderPackagesLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null) {
        emit(ProviderPackagesError("User not found"));
        return;
      }

      final data = await getProviderServicePackagesFunction(
        request: GetProviderServicePackagesRequest(
          providerId: user.userid ?? 5,
        ),
      );

      emit(ProviderPackagesSuccess(data));
    } catch (e) {
      emit(ProviderPackagesError(e.toString()));
    }
  }

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

      if (user == null) {
        emit(ProviderPackagesError("User not found"));
        return;
      }

      await createServicePackageFunction(
        request: CreateServicePackageRequest(
          provId: user.userid ?? 5,
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

      final data = await getProviderServicePackagesFunction(
        request: GetProviderServicePackagesRequest(
          providerId: user.userid ?? 5,
        ),
      );

      emit(ProviderPackagesSuccess(data));
    } catch (e) {
      emit(ProviderPackagesError(e.toString()));
    }
  }
}