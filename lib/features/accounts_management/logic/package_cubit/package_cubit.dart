import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/packages/get_package_model/get_package_repository.dart';
import 'package:sun_web_system/core/api_functions/packages/get_package_model/get_package_request.dart';
import 'package:sun_web_system/core/api_functions/user/login_model/login_repository.dart';
import 'package:sun_web_system/features/accounts_management/logic/package_cubit/package_state.dart';

class PackageCubit extends Cubit<PackageState> {
  PackageCubit() : super(PackageInitial());

  Future<void> getPackages() async {
    emit(PackageLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      if (user == null) {
        emit(PackageError("User not found"));
        return;
      }

      final data = await getPackageFunction(
        request: GetPackageRequest(
          packageID: user.providerDetails?.packageid ?? 65,
        ),
      );

      emit(
        PackageSuccess(
          packages: data,
          startDate: user.providerDetails?.subscriptionstartdate,
          endDate: user.providerDetails?.subscriptionenddate,
        ),
      );
    } catch (e) {
      emit(PackageError(e.toString()));
    }
  }
}