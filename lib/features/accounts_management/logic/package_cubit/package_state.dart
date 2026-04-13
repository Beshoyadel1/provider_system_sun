import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/packages/get_package_model/get_package_request.dart';
import 'package:sun_web_system/core/api_functions/packages/get_package_model/package_model_get_package_repository.dart';

/// States
abstract class PackageState {}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageSuccess extends PackageState {
  final List<PackageModelGetPackageRepository> packages;

  PackageSuccess(this.packages);
}

class PackageError extends PackageState {
  final String message;

  PackageError(this.message);
}

