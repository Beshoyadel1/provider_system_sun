import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/auth_local_storage.dart';
import '../../../notifications/data/model/notification_payload.dart';
import '../../../notifications/data/notification_updates.dart';
import '../../data/model/service_request_model.dart';
import '../../data/model/readable_api_text.dart';
import '../../data/repository/service_requests_repository.dart';
import '../../data/request/service_offer_request.dart';
import 'service_requests_state.dart';

typedef ProviderIdLoader = Future<int> Function();

class ServiceRequestsCubit extends Cubit<ServiceRequestsState> {
  ServiceRequestsCubit(
      {ServiceRequestsRepository? repository,
      ProviderIdLoader? providerIdLoader,
      NotificationUpdates? updates})
      : _repository = repository ?? const NetworkServiceRequestsRepository(),
        _providerIdLoader = providerIdLoader ?? _loadStoredProviderId,
        _updates = updates ?? NotificationUpdates.instance,
        super(const ServiceRequestsInitial()) {
    _subscription = _updates.stream.listen(_onNotification);
  }
  final ServiceRequestsRepository _repository;
  final ProviderIdLoader _providerIdLoader;
  final NotificationUpdates _updates;
  late final StreamSubscription<NotificationPayload> _subscription;
  List<ServiceRequestModel> requests = const [];
  ServiceRequestModel? selectedRequest;
  int? providerId;
  int _userType = 4, _session = 0, _revision = 0, _views = 0, _selection = 0;
  bool _hasLoaded = false, _operationBusy = false;
  Future<void>? _listRequest;
  final _details = <int, ServiceRequestModel>{};
  final _detailRequests = <int, Future<ServiceRequestModel>>{};
  final _pendingDetailPatches = <int, Map<String, dynamic>>{};
  final _awaitingRefresh = <int>{};
  final _versions = <int, int>{};
  final _removed = <int>{},
      _pending = <int>{},
      _unread = <int>{},
      _received = <int>{};
  int get unreadCount => _unread.length;
  bool get hasLoaded => _hasLoaded;
  bool get pageIsOpen => _views > 0;
  bool get canEditSelected =>
      selectedRequest?.isOpen == true &&
      !_awaitingRefresh.contains(selectedRequest?.id);

  static Future<int> _loadStoredProviderId() async {
    final user = await AuthLocalStorage.getUser();
    final id = user?.userid;
    if (id == null || id <= 0) throw Exception('User not found');
    return id;
  }

  void configureUser(int id, int type) {
    if (providerId == id && _userType == type) return;
    reset();
    providerId = id;
    _userType = type;
  }

  Future<int> _ensureProviderId() async {
    if (providerId != null) return providerId!;
    final session = _session;
    final id = await _providerIdLoader();
    if (session != _session) throw StateError('Account changed');
    providerId = id;
    return id;
  }

  void enterPage() {
    _views++;
    markSeen();
  }

  void leavePage() {
    if (_views > 0) _views--;
  }

  void markSeen() {
    if (_unread.isEmpty) return;
    _unread.clear();
    _changed();
  }

  void _changed() {
    // Each mutation needs a new state so consecutive updates rebuild the UI.
    if (!isClosed && !_operationBusy) emit(ServiceRequestsChanged());
  }

  void _put(ServiceRequestModel request) {
    _versions[request.id] = ++_revision;
    final byId = {for (final r in requests) r.id: r};
    if (request.isOpen && !_removed.contains(request.id)) {
      byId[request.id] = request;
    } else {
      byId.remove(request.id);
      _removed.add(request.id);
      _pending.remove(request.id);
      _unread.remove(request.id);
    }
    requests = _sorted(byId.values);
  }

  static List<ServiceRequestModel> _sorted(
      Iterable<ServiceRequestModel> items) {
    final result = items.toList();
    result.sort((a, b) =>
        (b.date ?? DateTime(1970)).compareTo(a.date ?? DateTime(1970)));
    return List.unmodifiable(result);
  }

  Future<void> loadRequests({bool force = false}) async {
    final session = _session;
    try {
      final id = await _ensureProviderId();
      if (session != _session) return;
      if (_listRequest != null) {
        await _listRequest;
        return;
      }
      if (_hasLoaded && !force) {
        _changed();
        return;
      }
      final pending = _loadList(id, session);
      _listRequest = pending;
      try {
        await pending;
      } finally {
        if (session == _session) _listRequest = null;
      }
    } catch (error) {
      if (session == _session && !isClosed) {
        emit(ServiceRequestsError(_message(error)));
      }
    }
  }

  Future<void> _loadList(int id, int session) async {
    final before = _revision;
    emit(const ServiceRequestsLoading());
    final loaded = await _repository.getRequests(providerId: id);
    if (session != _session || isClosed) return;
    final byId = <int, ServiceRequestModel>{};
    for (final item in loaded) {
      if (!item.isOpen || _removed.contains(item.id)) continue;
      byId[item.id] = item.copyWith(
          hasMyOffer: _details[item.id]?.hasMyOffer ?? item.hasMyOffer);
      _pending.remove(item.id);
    }
    // Preserve arrivals during this fetch; a fresh snapshot replaces older absent rows.
    for (final item in requests) {
      if ((_versions[item.id] ?? 0) > before &&
          item.isOpen &&
          !_removed.contains(item.id)) {
        byId[item.id] = item;
      }
    }
    _details.removeWhere((key, _) => !byId.containsKey(key));
    requests = _sorted(byId.values);
    _hasLoaded = true;
    _changed();
    await _hydratePending();
  }

  void _onNotification(NotificationPayload payload) {
    final id = providerId;
    if (id == null || !payload.isFor(id, _userType)) return;
    if (payload.kind == NotificationKind.offerAccepted) {
      final offerId = payload.integer('offerId');
      var requestId = payload.integer('requestId');
      if (requestId == null && offerId != null) {
        for (final details in _details.values) {
          if (details.offers.any((offer) => offer.id == offerId)) {
            requestId = details.id;
            break;
          }
        }
      }
      if (requestId != null) _remove(requestId);
      return;
    }
    if (payload.kind != NotificationKind.serviceRequest) return;
    final item = NotificationPayload.object(
        payload.get('item') ?? payload.get('requestInfo'));
    final requestId =
        payload.integer('requestId') ?? int.tryParse('${item['id']}');
    if (requestId == null || requestId <= 0 || _removed.contains(requestId)) {
      return;
    }
    if (_received.add(requestId) && !pageIsOpen) _unread.add(requestId);
    final patch = <String, dynamic>{...item, 'id': requestId};
    if (payload.get('status') != null) {
      patch['status'] = payload.integer('status');
    }
    if (payload.get('plateNo') != null) {
      patch['car'] = {
        ...NotificationPayload.object(patch['car']),
        'plateNo': payload.get('plateNo')
      };
    }
    if (_pendingDetailPatches.containsKey(requestId)) {
      final changes = _pendingDetailPatches[requestId]!;
      for (final entry in patch.entries) {
        changes[entry.key] = entry.value is Map && changes[entry.key] is Map
            ? {...changes[entry.key] as Map, ...entry.value as Map}
            : entry.value;
      }
    }
    final existing = requests.where((r) => r.id == requestId).firstOrNull;
    if (existing != null) {
      _put(existing.applyPatch(patch));
      if (_details[requestId] != null) {
        _details[requestId] = _details[requestId]!.applyPatch(patch);
      }
      if (selectedRequest?.id == requestId) {
        selectedRequest = selectedRequest!.applyPatch(patch);
      }
    } else if (item['user'] is Map &&
        item['service'] is Map &&
        item['car'] is Map &&
        item.containsKey('price')) {
      _put(ServiceRequestModel.fromJson(patch));
      _pending.remove(requestId);
    } else {
      _versions[requestId] = ++_revision;
      _pending.add(requestId);
    }
    _changed();
    if (_hasLoaded) unawaited(_hydratePending());
  }

  Future<void> _hydratePending() async {
    if (!_hasLoaded) return;
    final session = _session;
    for (final id in _pending.toList()) {
      try {
        await _fetchDetails(id);
      } catch (error) {
        if (session == _session && !isClosed) {
          emit(ServiceRequestsError(_message(error)));
        }
      }
      if (session != _session) return;
    }
    if (session == _session) _changed();
  }

  Future<ServiceRequestModel> _fetchDetails(int id,
      {bool force = false}) async {
    final session = _session;
    if (_detailRequests[id] != null) {
      final result = await _detailRequests[id]!;
      if (!force || session != _session) return result;
    }
    if (!force && _details[id] != null) return _details[id]!;
    _pendingDetailPatches[id] = {};
    final pending = () async {
      var result = await _repository.getDetails(id);
      if (session != _session || isClosed) return result;
      result = result.applyPatch(_pendingDetailPatches[id] ?? {});
      if (_removed.contains(id) && result.isOpen) {
        result = result.copyWith(status: 1);
      }
      final mine = result.offers
          .where((o) => o.provider.id == providerId)
          .toList(growable: false);
      result = result.copyWith(offers: mine, hasMyOffer: mine.isNotEmpty);
      _details[id] = result;
      _awaitingRefresh.remove(id);
      _pending.remove(id);
      _put(result);
      return result;
    }();
    _detailRequests[id] = pending;
    try {
      return await pending;
    } finally {
      if (session == _session) {
        _detailRequests.remove(id);
        _pendingDetailPatches.remove(id);
      }
    }
  }

  Future<void> openDetails(int requestId, {bool force = false}) async {
    final session = _session, selection = ++_selection;
    emit(const ServiceRequestDetailsLoading());
    try {
      await _ensureProviderId();
      if (session != _session) return;
      final details = await _fetchDetails(requestId, force: force);
      if (session != _session || selection != _selection || isClosed) return;
      selectedRequest = details;
      _changed();
    } catch (error) {
      if (session == _session && selection == _selection && !isClosed) {
        emit(ServiceRequestsError(_message(error)));
      }
    }
  }

  void closeDetails() {
    _selection++;
    selectedRequest = null;
    _changed();
  }

  bool _canMutate(int id) =>
      !_operationBusy && selectedRequest?.id == id && canEditSelected;

  Future<void> createOffer(ServiceOfferRequest request) async {
    if (!_canMutate(request.serviceRequestId) ||
        request.providerId != providerId ||
        selectedRequest!.offers.isNotEmpty) {
      return;
    }
    await _offerOperation(() async {
      final offerId = await _repository.createOffer(request);
      if (offerId <= 0) throw StateError('Invalid offer ID');
    }, request.serviceRequestId);
  }

  Future<void> updateOffer(ServiceOfferRequest request) async {
    if (!_canMutate(request.serviceRequestId) ||
        request.providerId != providerId ||
        !selectedRequest!.offers
            .any((offer) => offer.id == request.id && offer.status == 0)) {
      return;
    }
    await _offerOperation(
        () => _repository.updateOffer(request), request.serviceRequestId);
  }

  Future<void> _offerOperation(
      Future<void> Function() write, int requestId) async {
    final session = _session;
    _operationBusy = true;
    emit(const ServiceRequestOperationLoading());
    var saved = false;
    try {
      await write();
      if (session != _session || isClosed) return;
      saved = true;
      _awaitingRefresh.add(requestId);
      _details.remove(requestId);
      final details = await _fetchDetails(requestId, force: true);
      if (session != _session || isClosed) return;
      if (selectedRequest?.id == requestId) selectedRequest = details;
      emit(const ServiceRequestOperationSuccess(null));
    } catch (error) {
      if (session == _session && !isClosed) {
        emit(saved
            ? ServiceRequestSavedRefreshError(_message(error))
            : ServiceRequestsError(_message(error)));
      }
    } finally {
      if (session == _session) _operationBusy = false;
    }
  }

  Future<void> deleteOffer(int offerId) async {
    final details = selectedRequest;
    if (details == null ||
        !_canMutate(details.id) ||
        !details.offers.any((o) => o.id == offerId && o.status == 0)) {
      return;
    }
    final session = _session;
    _operationBusy = true;
    emit(const ServiceRequestOperationLoading());
    try {
      await _repository.deleteOffer(offerId);
      if (session != _session || isClosed) return;
      final latest = _details[details.id] ?? details;
      final offers =
          latest.offers.where((o) => o.id != offerId).toList(growable: false);
      final updated = latest.copyWith(
          offers: offers,
          hasMyOffer: offers.isNotEmpty,
          offersCount: latest.offersCount > 0 ? latest.offersCount - 1 : 0);
      _details[details.id] = updated;
      if (selectedRequest?.id == details.id) selectedRequest = updated;
      _put(updated);
      emit(const ServiceRequestOperationSuccess(null));
    } catch (error) {
      if (session == _session && !isClosed) {
        emit(ServiceRequestsError(_message(error)));
      }
    } finally {
      if (session == _session) _operationBusy = false;
    }
  }

  void _remove(int id) {
    _removed.add(id);
    _versions[id] = ++_revision;
    _details.remove(id);
    _awaitingRefresh.remove(id);
    _pending.remove(id);
    _unread.remove(id);
    requests = List.unmodifiable(requests.where((r) => r.id != id));
    if (selectedRequest?.id == id) {
      closeDetails();
    } else {
      _changed();
    }
  }

  Future<void> refuseSelectedRequest() async {
    final request = selectedRequest;
    if (request == null || !_canMutate(request.id) || providerId == null) {
      return;
    }
    final session = _session;
    _operationBusy = true;
    emit(const ServiceRequestOperationLoading());
    try {
      final message = await _repository.refuseRequest(
          providerId: providerId!, requestId: request.id);
      if (session != _session || isClosed) return;
      _remove(request.id);
      emit(ServiceRequestOperationSuccess(message));
    } catch (error) {
      if (session == _session && !isClosed) {
        emit(ServiceRequestsError(_message(error)));
      }
    } finally {
      if (session == _session) _operationBusy = false;
    }
  }

  void reset() {
    _session++;
    _selection++;
    _revision = 0;
    _views = 0;
    providerId = null;
    _hasLoaded = _operationBusy = false;
    _listRequest = null;
    requests = const [];
    selectedRequest = null;
    _details.clear();
    _detailRequests.clear();
    _pending.clear();
    _unread.clear();
    _received.clear();
    _removed.clear();
    _pendingDetailPatches.clear();
    _awaitingRefresh.clear();
    _versions.clear();
    if (!isClosed) emit(const ServiceRequestsInitial());
  }

  static String _message(Object error) =>
      readableApiText(error.toString().replaceFirst('Exception: ', ''));
  @override
  Future<void> close() async {
    reset();
    await _subscription.cancel();
    return super.close();
  }
}
