import 'dart:async';
import 'package:sun_web_system/features/service_requests/presentation/cubit/service_requests_cubit.dart';
import 'package:sun_web_system/features/service_requests/data/service_offer_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/audio_service/audio_service.dart';
import 'package:sun_web_system/core/setup_git_it.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/firebase_options.dart';
import 'package:sun_web_system/features/notifications/data/model/notification_payload.dart';
import 'package:sun_web_system/features/notifications/data/notification_updates.dart';
import 'package:sun_web_system/features/notifications/presentation/bloc/notification_cubit/notification_cubit.dart';
import 'package:sun_web_system/features/notifications/presentation/module/notification_module/notification_module.dart';
import 'package:sun_web_system/features/technical_support/data/model/chat_events/chat_events.dart';
import 'package:sun_web_system/features/notifications/data/model/receive_message_notification_model/receive_message_notification_model.dart';
import 'browser_notification.dart';
import 'notification_clicks.dart';
import 'fcm_message_transport.dart';
import 'package:sun_web_system/features/technical_support/presentation/bloc/provider_chat_cubit/provider_chat_cubit.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
}

class FcmService {
  FcmService({
    FcmMessageTransport? transport,
    NotificationCubit? notificationCubit,
    ProviderChatCubit? chatCubit,
    NotificationUpdates? updates,
    Future<void> Function()? playMessageSound,
    Future<void> Function()? stopSounds,
    Future<void> Function()? dismissDialog,
    void Function(NotificationPayload)? openPayload,
    void Function(NotificationPayload)? showOrderNotification,
    void Function()? Function(void Function(Map<String, dynamic>, bool))?
        webListener,
  })  : _transport = transport,
        _notificationCubit = notificationCubit,
        _chatCubit = chatCubit,
        _updates = updates ?? NotificationUpdates.instance,
        _playMessageSound =
            playMessageSound ?? AudioService.instance.playMessageSoundOnce,
        _stopSounds = stopSounds ?? AudioService.instance.stopNotificationSound,
        _dismissDialog = dismissDialog,
        _openPayload = openPayload,
        _showOrderNotification = showOrderNotification,
        _webListener = webListener;
  static final FcmService instance = FcmService();
  final FcmMessageTransport? _transport;
  final NotificationCubit? _notificationCubit;
  final ProviderChatCubit? _chatCubit;
  final NotificationUpdates _updates;
  final Future<void> Function() _playMessageSound;
  final Future<void> Function() _stopSounds;
  final Future<void> Function()? _dismissDialog;
  final void Function(NotificationPayload)? _openPayload,
      _showOrderNotification;
  final void Function()? Function(void Function(Map<String, dynamic>, bool))?
      _webListener;
  NotificationCubit get _notifications =>
      _notificationCubit ?? getIt<NotificationCubit>();
  ProviderChatCubit get _chat => _chatCubit ?? getIt<ProviderChatCubit>();
  Future<void> _dismiss() =>
      _dismissDialog?.call() ??
      NotificationModule.instance.dialogService.dismiss();
  String? _fcmToken;
  String? get fcmToken => _fcmToken;
  bool _isInitialized = false, _uiReady = false;
  bool get isInitialized => _isInitialized;
  int _userId = 0, _userType = 0, _session = 0;
  int? _authRevision;
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription, _openSubscription;
  final Set<String> _processed = {}, _opened = {};
  final List<({NotificationPayload payload, bool opened})> _pendingDisplay = [];
  void Function()? _stopWebClicks;

  static bool get isSupported =>
      kIsWeb ||
      const {TargetPlatform.android, TargetPlatform.iOS, TargetPlatform.macOS}
          .contains(defaultTargetPlatform);

  bool _isCurrentSession(int session, int revision) =>
      session == _session && AuthLocalStorage.isCurrentSession(revision);

  Future<void> init({required int userId, required int userType}) async {
    final revision = AuthLocalStorage.sessionRevision;
    if (_userId != userId ||
        _userType != userType ||
        _authRevision != revision) {
      final deviceToken = _fcmToken;
      final nextSession = _session + 1;
      await disconnect();
      if (!_isCurrentSession(nextSession, revision)) return;
      _fcmToken = deviceToken;
      _userId = userId;
      _userType = userType;
      _authRevision = revision;
    }
    _notifications.configureUser(userId, userType);
    if (getIt.isRegistered<ServiceRequestsCubit>()) {
      getIt<ServiceRequestsCubit>().configureUser(userId, userType);
    }
    final chat = _chat;
    chat.configureUser(userId, userType);
    unawaited(_notifications.ensureLoaded());
    // One initial conversation snapshot gives the sidebar its existing unread count.
    unawaited(chat.ensureMessagesLoaded());
    if ((_transport == null && !isSupported) || _isInitialized) return;
    _isInitialized = true;
    final session = _session;
    try {
      void handleWebPayload(Map<String, dynamic> raw, bool opened) {
        if (!_isCurrentSession(session, revision)) return;
        final notification = NotificationPayload.object(raw['notification']);
        final data = Map<String, dynamic>.of(raw)..remove('sunOpened');
        _handlePayload(
            NotificationPayload(
              data,
              title: notification['title']?.toString(),
              body: notification['body']?.toString(),
              messageId: (raw['messageId'] ?? raw['fcmMessageId'])?.toString(),
              sentAt: raw['sentTime'] is num
                  ? DateTime.fromMillisecondsSinceEpoch(
                      (raw['sentTime'] as num).toInt())
                  : DateTime.tryParse('${raw['sentAt'] ?? ''}'),
            ),
            opened: opened);
      }

      // Failure in the optional browser bridge must not disable foreground FCM.
      try {
        _stopWebClicks = _webListener != null
            ? _webListener(handleWebPayload)
            : listenForNotificationClicks((raw) => handleWebPayload(raw, true),
                onMessage: (raw) => handleWebPayload(raw, false));
      } catch (_) {}
      final transport = _transport ?? FirebaseMessageTransport();
      _tokenSubscription = transport.tokenRefresh.listen((token) {
        final clean = token.trim();
        if (clean.isEmpty || !_isCurrentSession(session, revision)) return;
        _fcmToken = clean;
        unawaited(_saveDeviceToken(clean, revision));
      });
      _messageSubscription = transport.messages.listen((message) {
        if (_isCurrentSession(session, revision)) {
          _handleRemoteMessage(message, opened: false);
        }
      });
      _openSubscription = transport.openedMessages.listen((message) {
        if (_isCurrentSession(session, revision)) {
          _handleRemoteMessage(message, opened: true);
        }
      });
      RemoteMessage? initial;
      try {
        initial = await transport.getInitialMessage();
      } catch (_) {}
      if (!_isCurrentSession(session, revision)) return;
      if (initial != null) _handleRemoteMessage(initial, opened: true);
    } catch (_) {
      if (session == _session) {
        await _tokenSubscription?.cancel();
        await _messageSubscription?.cancel();
        await _openSubscription?.cancel();
        // The browser bridge receives SDK worker packets independently. An SDK
        // stream failure must not disconnect that working delivery path.
        _isInitialized = false;
      }
    }
  }

  ({int revision, Future<String> token})? _pendingGetToken;

  /// Gets the device token after requesting notification permission.
  Future<String> getToken({
    String? vapidKey,
    bool promptForPermission = true,
  }) async {
    if (!isSupported) return '';
    final session = _session;
    final revision = AuthLocalStorage.sessionRevision;
    final token = await _fetchDeviceToken(
      revision,
      vapidKey: vapidKey,
      promptForPermission: promptForPermission,
    );
    return _storeFetchedToken(token, session, revision);
  }

  Future<String> _fetchDeviceToken(
    int revision, {
    String? vapidKey,
    required bool promptForPermission,
  }) async {
    final current = _pendingGetToken;
    if (current != null && current.revision == revision) {
      return current.token;
    }
    final pending = _requestDeviceToken(
      revision,
      vapidKey: vapidKey,
      promptForPermission: promptForPermission,
    );
    _pendingGetToken = (revision: revision, token: pending);
    try {
      return await pending;
    } finally {
      if (identical(_pendingGetToken?.token, pending)) _pendingGetToken = null;
    }
  }

  Future<String> _requestDeviceToken(
    int revision, {
    String? vapidKey,
    required bool promptForPermission,
  }) async {
    try {
      final messaging = FirebaseMessaging.instance;
      final permission = promptForPermission
          ? messaging.requestPermission(alert: true, badge: true, sound: true)
          : messaging.getNotificationSettings();
      final settings = await permission;
      if (!AuthLocalStorage.isCurrentSession(revision)) return '';
      final status = settings.authorizationStatus;
      if (status == AuthorizationStatus.denied ||
          status == AuthorizationStatus.deniedPermanently ||
          (!promptForPermission &&
              status == AuthorizationStatus.notDetermined)) {
        return '';
      }

      if (kIsWeb) {
        await prepareFcmWorker().timeout(const Duration(seconds: 15));
        if (!AuthLocalStorage.isCurrentSession(revision)) return '';
      }

      final key = vapidKey?.trim();
      final effectiveKey =
          key == null || key.isEmpty ? FcmConfig.webVapidKey.trim() : key;
      final token = await messaging
          .getToken(
            vapidKey: kIsWeb && effectiveKey.isNotEmpty ? effectiveKey : null,
          )
          .timeout(const Duration(seconds: kIsWeb ? 30 : 10));
      if (!AuthLocalStorage.isCurrentSession(revision)) return '';
      return token?.trim() ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<String> _storeFetchedToken(
      String token, int session, int revision) async {
    if (token.isEmpty || !_isCurrentSession(session, revision)) return '';
    _fcmToken = token;
    await _saveDeviceToken(token, revision);
    return _isCurrentSession(session, revision) ? token : '';
  }

  Future<void> _saveDeviceToken(String token, int revision) async {
    try {
      await AuthLocalStorage.saveFcmToken(token, revision: revision);
    } catch (_) {}
  }

  bool _remember(Set<String> keys, String key) {
    if (!keys.add(key)) return false;
    if (keys.length > 500) keys.remove(keys.first);
    return true;
  }

  void _handleRemoteMessage(RemoteMessage message, {required bool opened}) {
    final payload = NotificationPayload(message.data,
        title: message.notification?.title,
        body: message.notification?.body,
        messageId: message.messageId,
        sentAt: message.sentTime);
    _handlePayload(payload, opened: opened);
  }

  void _handlePayload(NotificationPayload payload, {required bool opened}) {
    if (_userId == 0) return;
    final isProviderChat = payload.kind == NotificationKind.chat &&
        (payload.integer('harageId') ?? 0) == 0;
    if (!payload.isFor(_userId, _userType)) {
      if (isProviderChat) _chat.refreshVisibleChatFromPush(payload);
      return;
    }
    if (isProviderChat && !_chat.acceptsMessagePayload(payload)) {
      _chat.refreshVisibleChatFromPush(payload);
      return;
    }
    try {
      // A status without a transport ID can recur (open -> closed -> open).
      // Content alone cannot identify that event across separate transitions.
      final repeatableStatus = payload.kind == NotificationKind.chatStatus &&
          payload.messageId?.isNotEmpty != true;
      final firstDelivery = _remember(_processed, payload.key);
      if (firstDelivery || (repeatableStatus && !opened)) {
        final isChat = payload.kind == NotificationKind.chat;
        final isHarag = isChat && (payload.integer('harageId') ?? 0) > 0;
        final alreadyKnown = isChat &&
            !isHarag &&
            _chat.containsMessage(payload.integer('id') ?? 0);
        _updates.add(payload);
        if (payload.isOrder) {
          _updates.enrichOrder(payload).ignore();
        }
        var shouldDisplay = !alreadyKnown;
        if (payload.kind == NotificationKind.chat) {
          final data = Map<String, dynamic>.of(payload.data);
          data['message'] ??= payload.body;
          ChatEvents.instance.add(ReceiveMessageData.fromJson(data));
        } else if (payload.kind == NotificationKind.chatStatus) {
          shouldDisplay = !opened && _chat.applyChatStatusPayload(payload);
        }
        if (!opened && shouldDisplay) _displayWhenReady(payload, false);
        _notifications.applyPush(payload);
      }
      // A click still navigates when this message was already applied in foreground.
      if (opened && (repeatableStatus || _remember(_opened, payload.key))) {
        _displayWhenReady(payload, true);
      }
    } catch (_) {}
  }

  void _displayWhenReady(NotificationPayload payload, bool opened) {
    final revision = _authRevision;
    final session = _session;
    if (revision == null || !_isCurrentSession(session, revision)) return;
    if (!_uiReady) {
      _pendingDisplay.add((payload: payload, opened: opened));
      if (_pendingDisplay.length > 20) _pendingDisplay.removeAt(0);
      return;
    }

    void openPayload() {
      if (!_isCurrentSession(session, revision) || !_uiReady) return;
      if (_openPayload != null) {
        _openPayload(payload);
      } else {
        NotificationModule.instance.navigationService.openPayload(payload);
      }
    }

    if (opened) {
      if (payload.kind == NotificationKind.chatStatus &&
          NotificationPayload.boolean(payload.get('isclosed')) == true) {
        return;
      }
      () async {
        await _dismiss();
        if (!_isCurrentSession(session, revision)) return;
        await _stopSounds();
        openPayload();
      }()
          .ignore();
    } else if (payload.kind == NotificationKind.chat) {
      if (payload.integer('fromuser') == _userId &&
          payload.integer('fromusertype') == _userType) {
        return;
      }
      final harageId = payload.integer('harageId') ?? 0;
      final isVisible = harageId > 0
          ? ChatEvents.instance.isHarageActive(harageId)
          : _chat.isVisibleConversation(payload);
      if (!isVisible) unawaited(_playMessageSound());
    } else if (payload.kind == NotificationKind.chatStatus) {
      unawaited(_playMessageSound());
    } else if (payload.isOrder ||
        payload.kind == NotificationKind.serviceRequest ||
        payload.kind == NotificationKind.serviceOffer ||
        payload.kind == NotificationKind.ownership) {
      if (payload.isOrder && _showOrderNotification != null) {
        _showOrderNotification(payload);
        return;
      }
      final orderId = payload.orderId;
      final title = payload.title.trim().isNotEmpty
          ? payload.title
          : payload.kind == NotificationKind.newOrder && (orderId ?? 0) > 0
              ? 'طلب جديد #$orderId'
              : 'إشعار جديد';
      unawaited(NotificationModule.instance.dialogService.show(
        title: title,
        subtitle: payload.body,
        onView: () async => openPayload(),
      ));
      showBrowserNotification(title, payload.body, onClick: () {
        if (_isCurrentSession(session, revision)) {
          _handlePayload(payload, opened: true);
        }
      });
    }
  }

  void markUiReady() {
    if (_userId == 0 || _uiReady) return;
    _uiReady = true;
    final pending = List.of(_pendingDisplay);
    _pendingDisplay.clear();
    // A launch click takes priority over older foreground popups.
    final clicks = pending.where((p) => p.opened).toList();
    if (clicks.isNotEmpty) {
      _displayWhenReady(clicks.last.payload, true);
    } else {
      for (final item in pending) {
        _displayWhenReady(item.payload, false);
      }
    }
  }

  Future<void> disconnect() async {
    _session++;
    _isInitialized = _uiReady = false;
    _userId = _userType = 0;
    _authRevision = null;
    _fcmToken = null;
    _pendingGetToken = null;
    _processed.clear();
    _opened.clear();
    _pendingDisplay.clear();
    _stopWebClicks?.call();
    _stopWebClicks = null;
    final cancellations = [
      if (_tokenSubscription != null) _tokenSubscription!.cancel(),
      if (_messageSubscription != null) _messageSubscription!.cancel(),
      if (_openSubscription != null) _openSubscription!.cancel(),
    ];
    _tokenSubscription = null;
    _messageSubscription = _openSubscription = null;
    _updates.reset();
    ChatEvents.instance.clearActiveHarages();
    ServiceOfferOptions.instance.reset();
    if (getIt.isRegistered<ServiceRequestsCubit>()) {
      getIt<ServiceRequestsCubit>().reset();
    }
    if (_notificationCubit != null || getIt.isRegistered<NotificationCubit>()) {
      _notifications.reset();
    }
    if (_chatCubit != null || getIt.isRegistered<ProviderChatCubit>()) {
      _chat.reset();
    }
    await Future.wait([_dismiss(), _stopSounds(), ...cancellations]);
  }
}
