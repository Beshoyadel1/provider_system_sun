abstract class CreateProvServiceState {}

class CreateProvServiceInitial extends CreateProvServiceState {}

class CreateProvServiceLoading extends CreateProvServiceState {}

class CreateProvServiceSuccess extends CreateProvServiceState {}

class CreateProvServiceError extends CreateProvServiceState {
  final String error;

  CreateProvServiceError(this.error);
}