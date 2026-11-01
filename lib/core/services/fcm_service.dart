import 'dart:async';
import '../api/api_json.dart';
import 'package:sun_web_system/features/service_requests/presentation/cubit/service_requests_cubit.dart';
import 'package:sun_web_system/features/service_requests/data/service_offer_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/api/dio_function/dio_controller.dart';
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
import 'notification_clicks.dart';
import 'fcm_message_transport.dart';
import 'package:sun_web_system/features/technical_support/presentation/bloc/provider_chat_cubit/provider_chat_cubit.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  debugPrint('FCM background: ${message.messageId}');
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
    void Function(String)? diagnosticLog,
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
        _diagnosticLog = diagnosticLog ?? debugPrint,
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
  final void Function(String) _diagnosticLog;
  void _trace(String message) {
    if (kDebugMode) _diagnosticLog('[FCM] $message');
  }

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
  String? _syncedToken;
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription, _openSubscription;
  final Set<String> _processed = {}, _opened = {};
  final Set<int> _serviceRequestSounds = {};
  final List<({NotificationPayload payload, bool opened})> _pendingDisplay = [];
  void Function()? _stopWebClicks;
  Future<void>? _tokenSync;

  static bool get isSupported =>
      kIsWeb ||
      const {TargetPlatform.android, TargetPlatform.iOS, TargetPlatform.macOS}
          .contains(defaultTargetPlatform);

  Future<void> init(
      {required int userId,
      required int userType,
      String? registeredToken}) async {
    if (_userId != userId || _userType != userType) {
      await disconnect();
      _userId = userId;
      _userType = userType;
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
    _syncedToken =
        registeredToken?.isNotEmpty == true ? registeredToken : _syncedToken;
    _fcmToken =
        registeredToken?.isNotEmpty == true ? registeredToken : _fcmToken;
    if ((_transport == null && !isSupported) || _isInitialized) return;
    _isInitialized = true;
    final session = _session;
    try {
      void handleWebPayload(Map<String, dynamic> raw, bool opened) {
        if (session != _session) return;
        final notification = NotificationPayload.object(raw['notification']);
        _handlePayload(
            NotificationPayload(
              raw,
              title: notification['title']?.toString(),
              body: notification['body']?.toString(),
              messageId: (raw['messageId'] ?? raw['fcmMessageId'])?.toString(),
            ),
            opened: opened,
            source:
                raw['isFirebaseMessaging'] == true ? 'browser-sdk' : 'worker');
      }

      // Failure in the optional browser bridge must not disable foreground FCM.
      try {
        _stopWebClicks = _webListener != null
            ? _webListener(handleWebPayload)
            : listenForNotificationClicks((raw) => handleWebPayload(raw, true),
                onMessage: (raw) => handleWebPayload(raw, false));
        _trace('browser-bridge-ready');
      } catch (e) {
        debugPrint('FCM browser bridge: $e');
      }
      final transport = _transport ?? FirebaseMessageTransport();
      _tokenSubscription = transport.tokenRefresh.listen((token) {
        if (session != _session) return;
        _fcmToken = token;
        unawaited(_syncTokenWithBackend(token, session));
      });
      _messageSubscription = transport.messages.listen((message) {
        if (session == _session) _handleRemoteMessage(message, opened: false);
      });
      _openSubscription = transport.openedMessages.listen((message) {
        if (session == _session) _handleRemoteMessage(message, opened: true);
      });
      _trace('listeners-ready');
      // Install account-wide listeners before permission prompts or initial-click
      // retrieval. Neither operation is allowed to tear down working listeners.
      unawaited(transport
          .requestPermission()
          .timeout(const Duration(seconds: 10))
          .catchError((Object e) {
        debugPrint('FCM permission: $e');
      }));
      RemoteMessage? initial;
      try {
        initial = await transport
            .getInitialMessage()
            .timeout(const Duration(seconds: 10));
      } catch (e) {
        debugPrint('FCM initial message: $e');
      }
      if (session != _session) return;
      if (initial != null) _handleRemoteMessage(initial, opened: true);
      // Login already registered its token and topics on the backend.
      if (_syncedToken == null) {
        final token = await getToken(vapidKey: FcmConfig.webVapidKey);
        if (session == _session && token.isNotEmpty) {
          await _syncTokenWithBackend(token, session);
        }
      }
    } catch (e) {
      debugPrint('FCM init: $e');
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

  Future<String>? _pendingGetToken;

  /// Retrieves the current device/browser FCM registration token.
  Future<String> getToken({String? vapidKey}) async {
    if (_fcmToken?.isNotEmpty == true) return _fcmToken!;
    if (_pendingGetToken != null) {
      return _pendingGetToken!;
    }
    _pendingGetToken = _internalGetToken(vapidKey: vapidKey);
    try {
      return await _pendingGetToken!;
    } finally {
      _pendingGetToken = null;
    }
  }

  Future<String> _internalGetToken({String? vapidKey}) async {
    // 1. Attempt to fetch real token from Firebase if supported
    if (isSupported) {
      try {
        final effectiveVapidKey =
            (vapidKey != null && vapidKey.trim().isNotEmpty)
                ? vapidKey.trim()
                : FcmConfig.webVapidKey.trim();

        if (kIsWeb) {
          try {
            final settings =
                await FirebaseMessaging.instance.getNotificationSettings();
            if (settings.authorizationStatus ==
                AuthorizationStatus.notDetermined) {
              final newSettings =
                  await FirebaseMessaging.instance.requestPermission();
              if (kDebugMode) {
                print(
                    'FCM Web: Requested notification permission => ${newSettings.authorizationStatus}');
              }
            } else if (settings.authorizationStatus ==
                AuthorizationStatus.denied) {
              if (kDebugMode) {
                print(
                    'FCM Web: Notification permission is DENIED by the user/browser.');
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print('FCM Web: Permission check note: $e');
            }
          }
        }

        final token = await FirebaseMessaging.instance
            .getToken(
          vapidKey: (kIsWeb && effectiveVapidKey.isNotEmpty)
              ? effectiveVapidKey
              : null,
        )
            .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (kDebugMode) {
              print('FCM: Token retrieval timed out after 10 seconds.');
            }
            return null;
          },
        );

        if (token != null && token.trim().isNotEmpty) {
          _fcmToken = token.trim();
          try {
            await AuthLocalStorage.saveFcmToken(_fcmToken!);
          } catch (_) {}
          if (kDebugMode) {
            debugPrint('FCM: Registration token obtained.');
          }
          return _fcmToken!;
        }
      } catch (e) {
        if (kDebugMode) {
          print('FCM: Firebase getToken attempt note: $e');
        }
      }
    } else {
      if (kDebugMode) {
        print(
            'FCM: Platform $defaultTargetPlatform does not support native Firebase Messaging.');
      }
    }

    // Never send a generated placeholder or a token from another user's model.
    _fcmToken = null;
    return '';
  }

  Future<void> syncCurrentToken({int? userId, int? userType}) async {
    if (_userId == 0) return;
    final session = _session;
    final token = await getToken(vapidKey: FcmConfig.webVapidKey);
    if (session == _session && token.isNotEmpty) {
      await _syncTokenWithBackend(token, session);
    }
  }

  Future<void> _syncTokenWithBackend(String token, int session) async {
    final clean = token.trim();
    if (clean.isEmpty ||
        clean == _syncedToken ||
        session != _session ||
        _userId == 0) {
      return;
    }
    if (_tokenSync != null) {
      await _tokenSync;
      if (session == _session && clean != _syncedToken) {
        await _syncTokenWithBackend(clean, session);
      }
      return;
    }
    final pending = _writeToken(clean, session);
    _tokenSync = pending;
    try {
      await pending;
    } finally {
      if (session == _session) _tokenSync = null;
    }
  }

  Future<void> _writeToken(String clean, int session) async {
    try {
      final response = await Network.postDataWithBody({
        'UserId': _userId,
        'UserType': _userType,
        'FcmToken': clean,
      }, ApiLink.updateFcmToken);
      if (session != _session) return;
      final body = response.data is Map
          ? ApiJson.object(response.data as Map)
          : null;
      if ((response.statusCode ?? 500) >= 400 ||
          body == null ||
          body['success'] != true ||
          body['status'] == false) {
        throw StateError('Token update rejected');
      }
      _syncedToken = clean;
      await AuthLocalStorage.saveFcmToken(clean);
      // UpdateFcmToken subscribes the account topic and all automatically.
    } catch (e) {
      debugPrint('FCM token sync: $e');
    }
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

  void _handlePayload(NotificationPayload payload,
      {required bool opened, String source = 'flutter-sdk'}) {
    _trace('received source=$source type=${payload.type} opened=$opened');
    if (_userId == 0 || !payload.isFor(_userId, _userType)) {
      _trace(
          'dropped account-or-endpoints-mismatch keys=${payload.data.keys.join(',')}');
      return;
    }
    if (payload.kind == NotificationKind.chat &&
        (payload.integer('harageId') ?? 0) == 0 &&
        !_chat.acceptsMessagePayload(payload)) {
      // No message text or registration token is logged. These flags distinguish
      // a delivery problem from an incomplete payload or a deleted conversation.
      _trace('dropped chat-payload: id=${payload.integer('id')} '
          'date=${payload.get('date')} '
          'message-present=${payload.get('message') != null} '
          'keys=${payload.data.keys.join(',')}');
      return;
    }
    try {
      // A status without a transport ID can recur (open -> closed -> open).
      // Content alone cannot identify that event across separate transitions.
      final repeatableStatus = payload.kind == NotificationKind.chatStatus &&
          payload.messageId?.isNotEmpty != true;
      final firstDelivery = _remember(_processed, payload.key);
      if (!firstDelivery) _trace('duplicate ${payload.kind.name}');
      if (firstDelivery || (repeatableStatus && !opened)) {
        final isChat = payload.kind == NotificationKind.chat;
        final isHarag = isChat && (payload.integer('harageId') ?? 0) > 0;
        final alreadyKnown = isChat &&
            !isHarag &&
            _chat.containsMessage(payload.integer('id') ?? 0);
        _updates.add(payload);
        if (payload.isOrder) {
          unawaited(_updates.enrichOrder(payload).catchError((Object e) {
            debugPrint('FCM missing order fields: $e');
          }));
        }
        _notifications.applyPush(payload);
        var shouldDisplay = !alreadyKnown;
        if (payload.kind == NotificationKind.chat) {
          final normalized = {
            for (final e in payload.data.entries)
              e.key.toLowerCase().replaceAll('_', ''): e.value
          };
          ChatEvents.instance.add(ReceiveMessageData.fromJson(normalized));
        } else if (payload.kind == NotificationKind.chatStatus) {
          shouldDisplay = !opened && _chat.applyChatStatusPayload(payload);
        }
        if (!opened && shouldDisplay) _displayWhenReady(payload, false);
      }
      // A click still navigates when this message was already applied in foreground.
      if (opened && (repeatableStatus || _remember(_opened, payload.key))) {
        _displayWhenReady(payload, true);
      }
    } catch (e, stack) {
      debugPrint('FCM handling: $e');
      debugPrintStack(stackTrace: stack);
    }
  }

  void _displayWhenReady(NotificationPayload payload, bool opened) {
    if (!_uiReady) {
      _pendingDisplay.add((payload: payload, opened: opened));
      return;
    }
    if (opened) {
      if (payload.kind == NotificationKind.chatStatus &&
          NotificationPayload.boolean(payload.get('isclosed')) == true) {
        return;
      }
      final session = _session;
      unawaited(_dismiss().then((_) {
        if (session == _session) {
          if (_openPayload != null) {
            _openPayload(payload);
          } else {
            NotificationModule.instance.navigationService.openPayload(payload);
          }
        }
      }));
    } else if (payload.kind == NotificationKind.chat) {
      if (payload.integer('fromuser') == _userId &&
          payload.integer('fromusertype') == _userType) {
        return;
      }
      if (!_chat.isVisibleConversation(payload)) unawaited(_playMessageSound());
    } else if (payload.kind == NotificationKind.chatStatus) {
      unawaited(_playMessageSound());
    } else if (payload.kind == NotificationKind.serviceRequest) {
      final id = payload.integer('requestId');
      if (id == null || _serviceRequestSounds.add(id)) {
        if (_serviceRequestSounds.length > 500) {
          _serviceRequestSounds.remove(_serviceRequestSounds.first);
        }
        unawaited(_playMessageSound());
      }
    } else if (payload.isOrder) {
      if (_showOrderNotification != null) {
        _showOrderNotification(payload);
        return;
      }
      unawaited(NotificationModule.instance.dialogService.show(
        title: payload.title.isNotEmpty ? payload.title : 'إشعار جديد',
        subtitle: payload.body,
        onView: () async =>
            NotificationModule.instance.navigationService.openPayload(payload),
      ));
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
    _syncedToken = _fcmToken = null;
    _tokenSync = null;
    _processed.clear();
    _opened.clear();
    _serviceRequestSounds.clear();
    _pendingDisplay.clear();
    _stopWebClicks?.call();
    _stopWebClicks = null;
    await _dismiss();
    await _tokenSubscription?.cancel();
    await _messageSubscription?.cancel();
    await _openSubscription?.cancel();
    _tokenSubscription = null;
    _messageSubscription = _openSubscription = null;
    _updates.reset();
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
    await _stopSounds();
    await AuthLocalStorage.deleteFcmToken();
  }
}
