import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/auth_local_storage.dart';
import '../../data/model/service_request_model.dart';
import '../../data/model/readable_api_text.dart';
import '../../data/repository/service_requests_repository.dart';
import '../../data/request/service_offer_request.dart';
import 'service_requests_state.dart';

typedef ProviderIdLoader = Future<int> Function();

class ServiceRequestsCubit extends Cubit<ServiceRequestsState> {
  ServiceRequestsCubit({
    ServiceRequestsRepository? repository,
    ProviderIdLoader? providerIdLoader,
  })  : _repository = repository ?? const NetworkServiceRequestsRepository(),
        _providerIdLoader = providerIdLoader ?? _loadStoredProviderId,
        super(const ServiceRequestsInitial());

  final ServiceRequestsRepository _repository;
  final ProviderIdLoader _providerIdLoader;

  List<ServiceRequestModel> requests = const [];
  ServiceRequestModel? selectedRequest;
  int unreadCount = 0;
  int? providerId;
  bool _hasLoaded = false;

  bool get hasLoaded => _hasLoaded;

  static Future<int> _loadStoredProviderId() async {
    final user = await AuthLocalStorage.getUser();
    final id = user?.userid;
    if (id == null || id == 0) throw Exception('User not found');
    return id;
  }

  Future<int> _ensureProviderId() async {
    final currentId = await _providerIdLoader();
    if (providerId != null && providerId != currentId) {
      requests = const [];
      selectedRequest = null;
      unreadCount = 0;
      _hasLoaded = false;
    }
    providerId = currentId;
    return currentId;
  }

  Future<void> loadRequests({bool force = false}) async {
    try {
      final id = await _ensureProviderId();
      if (_hasLoaded && !force) {
        emit(const ServiceRequestsChanged());
        return;
      }
      emit(const ServiceRequestsLoading());
      final loaded = await _repository.getRequests(
        providerId: id,
      );
      requests = _mergeRequests(loaded, requests);
      _hasLoaded = true;
      emit(const ServiceRequestsChanged());
    } catch (error) {
      emit(ServiceRequestsError(_message(error)));
    }
  }

  void addRealtimeRequest(
    ServiceRequestModel request, {
    required bool pageIsOpen,
  }) {
    requests = _mergeRequests([request], requests);
    if (!pageIsOpen) unreadCount++;
    emit(const ServiceRequestsChanged());
  }

  void notifyWithoutItem({required bool pageIsOpen}) {
    if (!pageIsOpen) unreadCount++;
    emit(const ServiceRequestsChanged());
  }

  void markSeen() {
    if (unreadCount == 0) return;
    unreadCount = 0;
    emit(const ServiceRequestsChanged());
  }

  Future<void> openDetails(int requestId) async {
    emit(const ServiceRequestDetailsLoading());
    try {
      final id = await _ensureProviderId();
      final details = await _repository.getDetails(requestId);
      selectedRequest = details.copyWith(
        offers: details.offers
            .where((offer) => offer.provider.id == id)
            .toList(growable: false),
      );
      emit(const ServiceRequestsChanged());
    } catch (error) {
      emit(ServiceRequestsError(_message(error)));
    }
  }

  void closeDetails() {
    selectedRequest = null;
    emit(const ServiceRequestsChanged());
  }

  Future<void> createOffer(ServiceOfferRequest request) async {
    await _runOfferOperation(
      () => _repository.createOffer(request),
      request.serviceRequestId,
    );
  }

  Future<void> updateOffer(ServiceOfferRequest request) async {
    await _runOfferOperation(
      () => _repository.updateOffer(request),
      request.serviceRequestId,
    );
  }

  Future<void> deleteOffer(int offerId) async {
    final details = selectedRequest;
    if (details == null) return;
    emit(const ServiceRequestOperationLoading());
    try {
      await _repository.deleteOffer(offerId);
      final remainingOffers = details.offers
          .where((offer) => offer.id != offerId)
          .toList(growable: false);
      final updatedCount = details.offersCount > 0
          ? details.offersCount - 1
          : details.offersCount;
      selectedRequest = details.copyWith(
        offers: remainingOffers,
        hasMyOffer: remainingOffers.isNotEmpty,
        offersCount: updatedCount,
      );
      requests = requests.map((item) {
        if (item.id != details.id) return item;
        return item.copyWith(
          hasMyOffer: remainingOffers.isNotEmpty,
          offersCount: updatedCount,
        );
      }).toList(growable: false);
      emit(const ServiceRequestOperationSuccess(null));
    } catch (error) {
      emit(ServiceRequestsError(_message(error)));
    }
  }

  Future<void> refuseSelectedRequest() async {
    final request = selectedRequest;
    if (request == null) return;
    emit(const ServiceRequestOperationLoading());
    try {
      final id = await _ensureProviderId();
      final message = await _repository.refuseRequest(
        providerId: id,
        requestId: request.id,
      );
      requests = requests
          .where((item) => item.id != request.id)
          .toList(growable: false);
      selectedRequest = null;
      emit(ServiceRequestOperationSuccess(message));
    } catch (error) {
      emit(ServiceRequestsError(_message(error)));
    }
  }

  Future<void> _runOfferOperation(
    Future<dynamic> Function() operation,
    int requestId,
  ) async {
    emit(const ServiceRequestOperationLoading());
    try {
      await operation();
      await _refreshDetailsAfterMutation(requestId);
      emit(const ServiceRequestOperationSuccess(null));
    } catch (error) {
      emit(ServiceRequestsError(_message(error)));
    }
  }

  Future<void> _refreshDetailsAfterMutation(int requestId) async {
    final id = await _ensureProviderId();
    final details = await _repository.getDetails(requestId);
    final mine = details.offers
        .where((offer) => offer.provider.id == id)
        .toList(growable: false);
    selectedRequest = details.copyWith(
      offers: mine,
      hasMyOffer: mine.isNotEmpty,
    );
    requests = requests.map((item) {
      if (item.id != requestId) return item;
      return item.copyWith(
        hasMyOffer: mine.isNotEmpty,
        offersCount: details.offersCount,
      );
    }).toList(growable: false);
  }

  static List<ServiceRequestModel> _mergeRequests(
    List<ServiceRequestModel> preferred,
    List<ServiceRequestModel> existing,
  ) {
    final byId = <int, ServiceRequestModel>{};
    for (final item in existing) {
      if (!item.isRefused) byId[item.id] = item;
    }
    for (final item in preferred) {
      if (!item.isRefused) byId[item.id] = item;
    }
    final result = byId.values.toList();
    result.sort((a, b) {
      final aDate = a.date ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.date ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return List.unmodifiable(result);
  }

  static String _message(Object error) {
    return readableApiText(error.toString().replaceFirst('Exception: ', ''));
  }
}
