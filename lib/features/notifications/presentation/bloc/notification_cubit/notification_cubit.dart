import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theming/auth_local_storage.dart';
import '../../../data/datasource/get_user_new_notification_datasource/get_user_new_notification_datasource.dart';
import '../../../data/datasource/get_user_notification_datasource/get_user_notification_datasource.dart';
import '../../../data/datasource/make_notification_viewed_datasource/make_notification_viewed_datasource.dart';
import '../../../data/model/get_user_new_notification_model/get_user_new_notification_model.dart';
import '../../../data/model/notification_payload.dart';
import '../../../data/request/get_user_new_notification_request/get_user_new_notification_request.dart';
import 'notification_state.dart';

typedef NotificationHistoryLoader = Future<GetUserNotificationResponse>
    Function({required GetUserNewNotificationRequest request});
typedef UnreadNotificationLoader = Future<List<NotificationModel>> Function(
    {required GetUserNewNotificationRequest request});
typedef NotificationReadWriter = Future<void> Function(
    {required GetUserNewNotificationRequest request});

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    NotificationHistoryLoader? historyLoader,
    UnreadNotificationLoader? unreadLoader,
    NotificationReadWriter? readWriter,
  })  : _historyLoader = historyLoader ?? getUserNotificationFunction,
        _unreadLoader = unreadLoader ?? getUserNewNotificationFunction,
        _readWriter = readWriter ?? makeNotificationViewedFunction,
        super(NotificationInitial());

  final NotificationHistoryLoader _historyLoader;
  final UnreadNotificationLoader _unreadLoader;
  final NotificationReadWriter _readWriter;
  List<NotificationModel> notifications = [];
  NotificationModel? newNotification;
  final Map<String, NotificationModel> _unread = {};
  final Map<String, int> _arrivalRevision = {};
  final Map<String, int> _readRevision = {};
  int get unreadCount => _unread.length;
  int _userId = 0, _userType = 0, _session = 0, _revision = 0;
  int _pageNumber = 1;
  final int _pageSize = 10;
  bool _historyLoaded = false, _unreadLoaded = false;
  Future<void>? _historyRequest, _unreadRequest, _readRequest;
  bool hasMore = false, isLoadingMore = false;
  int totalCount = 0, pageCount = 0;

  void configureUser(int userId, int userType) {
    if (_userId == userId && _userType == userType) return;
    reset();
    _userId = userId;
    _userType = userType;
  }

  void reset() {
    _session++;
    _userId = _userType = 0;
    _revision = 0;
    _pageNumber = 1;
    notifications = [];
    newNotification = null;
    _unread.clear();
    _arrivalRevision.clear();
    _readRevision.clear();
    _historyLoaded = _unreadLoaded = false;
    _historyRequest = _unreadRequest = _readRequest = null;
    hasMore = isLoadingMore = false;
    totalCount = pageCount = 0;
    safeEmit(NotificationInitial());
  }

  void safeEmit(NotificationState state) {
    if (!isClosed) emit(state);
  }

  bool _valid(int session) => !isClosed && session == _session;
  String _key(NotificationModel item) =>
      item.id != null ? 'notification:${item.id}' : item.localKey ?? '';

  GetUserNewNotificationRequest _request({int? page}) =>
      GetUserNewNotificationRequest(
          userId: _userId,
          userType: _userType,
          pageNumber: page,
          pageSize: page == null ? null : _pageSize);

  Future<bool> _hasUser() async {
    if (_userId > 0) return true;
    final user = await AuthLocalStorage.getUser();
    if (isClosed || user?.userid == null) return false;
    configureUser(user!.userid!, user.type ?? 4);
    return true;
  }

  Future<void> ensureLoaded() async {
    if (isClosed || !await _hasUser()) return;
    await Future.wait([
      if (!_historyLoaded) getUserNotification(),
      if (!_unreadLoaded) getUserNewNotification(),
    ]);
  }

  void _emitList() {
    notifications.sort((a, b) =>
        (b.date ?? DateTime(1970)).compareTo(a.date ?? DateTime(1970)));
    safeEmit(NotificationSuccess(List.unmodifiable(notifications)));
  }

  void applyPush(NotificationPayload payload) {
    if (isClosed ||
        _userId == 0 ||
        !payload.isFor(_userId, _userType) ||
        payload.kind == NotificationKind.chat ||
        payload.kind == NotificationKind.chatStatus) {
      return;
    }
    final item = NotificationModel.fromPush(payload);
    final key = _key(item);
    if (_arrivalRevision.containsKey(key)) return;
    _arrivalRevision[key] = ++_revision;
    final index = notifications.indexWhere((n) => _key(n) == key);
    if (index < 0) {
      notifications = [item, ...notifications];
      totalCount++;
    } else {
      notifications = List.of(notifications)..[index] = item;
    }
    if (item.isViewed != true) _unread[key] = item;
    newNotification = item;
    _emitList();
  }

  Future<void> getUserNotification() async {
    if (isClosed || !await _hasUser()) return;
    if (_historyRequest != null) return _historyRequest!;
    final session = _session, revision = _revision;
    final request = _request(page: 1);
    if (notifications.isEmpty) safeEmit(NotificationLoading());
    final pending = () async {
      try {
        final response = await _historyLoader(request: request);
        if (!_valid(session)) return;
        // Explicit refresh replaces transient entries lacking a database ID.
        final arrivals = notifications
            .where((n) => (_arrivalRevision[_key(n)] ?? 0) > revision)
            .toList();
        final merged = {
          for (final n in response.data)
            _key(n): (_readRevision[_key(n)] ?? 0) > revision
                ? n.copyWith(isViewed: true)
                : n
        };
        for (final n in arrivals) {
          merged[_key(n)] = n;
        }
        notifications = merged.values.toList();
        totalCount = response.totalCount +
            arrivals
                .where((n) => !response.data.any((s) => _key(s) == _key(n)))
                .length;
        pageCount = response.pageCount;
        _pageNumber = response.currentPage;
        hasMore = _pageNumber < pageCount;
        _historyLoaded = true;
        _emitList();
      } catch (e) {
        if (_valid(session)) safeEmit(NotificationError(e.toString()));
      }
    }();
    _historyRequest = pending;
    try {
      await pending;
    } finally {
      if (_valid(session)) _historyRequest = null;
    }
  }

  Future<void> getUserNewNotification() async {
    if (isClosed || !await _hasUser()) return;
    if (_unreadRequest != null) return _unreadRequest!;
    final session = _session, revision = _revision;
    final request = _request();
    final pending = () async {
      try {
        final items = await _unreadLoader(request: request);
        if (!_valid(session)) return;
        final arrivals = Map.of(_unread)
          ..removeWhere((key, _) => (_arrivalRevision[key] ?? 0) <= revision);
        _unread.clear();
        for (final item in items) {
          if (item.isViewed != true &&
              (_readRevision[_key(item)] ?? 0) <= revision) {
            _unread[_key(item)] = item;
          }
        }
        _unread.addAll(arrivals);
        _unreadLoaded = true;
        newNotification = items.isEmpty ? null : items.last;
        _emitList();
      } catch (e) {
        if (_valid(session)) safeEmit(NotificationError(e.toString()));
      }
    }();
    _unreadRequest = pending;
    try {
      await pending;
    } finally {
      if (_valid(session)) _unreadRequest = null;
    }
  }

  Future<void> makeNotificationViewed() async {
    if (isClosed || _userId == 0 || unreadCount == 0) return;
    if (_readRequest != null) return _readRequest!;
    final session = _session;
    final keys = _unread.keys.toSet();
    final request = _request();
    final pending = () async {
      try {
        await _readWriter(request: request);
        if (!_valid(session)) return;
        // Arrivals during this write remain unread locally.
        _unread.removeWhere((key, _) => keys.contains(key));
        final readVersion = ++_revision;
        for (final key in keys) {
          _readRevision[key] = readVersion;
        }
        notifications = notifications
            .map((n) => keys.contains(_key(n)) ? n.copyWith(isViewed: true) : n)
            .toList();
        _emitList();
      } catch (e) {
        if (_valid(session)) safeEmit(NotificationError(e.toString()));
      }
    }();
    _readRequest = pending;
    try {
      await pending;
    } finally {
      if (_valid(session)) _readRequest = null;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore || isClosed || _userId == 0) return;
    isLoadingMore = true;
    final session = _session, nextPage = _pageNumber + 1;
    try {
      final response = await _historyLoader(request: _request(page: nextPage));
      if (!_valid(session)) return;
      final merged = {
        for (final n in response.data) _key(n): n,
        for (final n in notifications) _key(n): n
      };
      notifications = merged.values.toList();
      _pageNumber = nextPage;
      pageCount = response.pageCount;
      hasMore = _pageNumber < pageCount;
      _emitList();
    } catch (e) {
      if (_valid(session)) safeEmit(NotificationError(e.toString()));
    } finally {
      if (_valid(session)) isLoadingMore = false;
    }
  }
}
