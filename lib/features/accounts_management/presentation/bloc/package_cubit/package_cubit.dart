import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/features/accounts_management/data/datasource/get_package_datasource/get_package_repository.dart';
import 'package:sun_web_system/features/accounts_management/data/request/get_package_request/get_package_request.dart';
import 'package:sun_web_system/features/accounts_management/presentation/bloc/package_cubit/package_state.dart';
import 'package:sun_web_system/features/auth_page/data/datasource/login_datasource/login_repository.dart';

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