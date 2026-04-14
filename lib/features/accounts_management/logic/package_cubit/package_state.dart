import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api_functions/packages/get_package_model/get_package_request.dart';
import 'package:sun_web_system/core/api_functions/packages/get_package_model/package_model_get_package_repository.dart';

abstract class PackageState {}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageSuccess extends PackageState {
  final List packages;
  final DateTime? startDate;
  final DateTime? endDate;

  PackageSuccess({
    required this.packages,
    required this.startDate,
    required this.endDate,
  });
}

class PackageError extends PackageState {
  final String message;
  PackageError(this.message);
}

