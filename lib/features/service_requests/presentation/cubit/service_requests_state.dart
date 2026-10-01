sealed class ServiceRequestsState {
  const ServiceRequestsState();
}

class ServiceRequestsInitial extends ServiceRequestsState {
  const ServiceRequestsInitial();
}

class ServiceRequestsLoading extends ServiceRequestsState {
  const ServiceRequestsLoading();
}

class ServiceRequestsChanged extends ServiceRequestsState {
  const ServiceRequestsChanged();
}

class ServiceRequestDetailsLoading extends ServiceRequestsState {
  const ServiceRequestDetailsLoading();
}

class ServiceRequestOperationLoading extends ServiceRequestsState {
  const ServiceRequestOperationLoading();
}

class ServiceRequestOperationSuccess extends ServiceRequestsState {
  const ServiceRequestOperationSuccess(this.message);
  final String? message;
}

class ServiceRequestsError extends ServiceRequestsState {
  const ServiceRequestsError(this.message);
  final String message;
}
