import 'dart:async';
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
  FcmService._();
  static final FcmService instance = FcmService._();
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
    getIt<NotificationCubit>().configureUser(userId, userType);
    getIt<ServiceRequestsCubit>().configureUser(userId, userType);
    final chat = getIt<ProviderChatCubit>();
    chat.configureUser(userId, userType);
    unawaited(getIt<NotificationCubit>().ensureLoaded());
    // One initial conversation snapshot gives the sidebar its existing unread count.
    unawaited(chat.ensureMessagesLoaded());
    _syncedToken =
        registeredToken?.isNotEmpty == true ? registeredToken : _syncedToken;
    _fcmToken =
        registeredToken?.isNotEmpty == true ? registeredToken : _fcmToken;
    if (!isSupported || _isInitialized) return;
    _isInitialized = true;
    final session = _session;
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      if (session != _session) return;
      _stopWebClicks = listenForNotificationClicks((raw) {
        if (session != _session) return;
        final notification = NotificationPayload.object(raw['notification']);
        _handlePayload(
            NotificationPayload(
              NotificationPayload.object(raw['data']),
              title: notification['title']?.toString(),
              body: notification['body']?.toString(),
              messageId: (raw['messageId'] ?? raw['fcmMessageId'])?.toString(),
            ),
            opened: true);
      });
      _tokenSubscription = messaging.onTokenRefresh.listen((token) {
        if (session != _session) return;
        _fcmToken = token;
        unawaited(_syncTokenWithBackend(token, session));
      });
      _messageSubscription = FirebaseMessaging.onMessage.listen((message) {
        if (session == _session) _handleRemoteMessage(message, opened: false);
      });
      _openSubscription =
          FirebaseMessaging.onMessageOpenedApp.listen((message) {
        if (session == _session) _handleRemoteMessage(message, opened: true);
      });
      final initial = await messaging.getInitialMessage();
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
            print('FCM: Successfully obtained new token: $_fcmToken');
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
      final response = await Network.postDataWithQuery({
        'userId': _userId,
        'userType': _userType,
        'fcmToken': clean,
      }, ApiLink.updateFcmToken);
      if (session != _session) return;
      final body = response.data;
      if ((response.statusCode ?? 500) >= 400 ||
          (body is Map &&
              (body['status'] == false || body['success'] == false))) {
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

  void _handlePayload(NotificationPayload payload, {required bool opened}) {
    if (_userId == 0 || !payload.isFor(_userId, _userType)) return;
    try {
      if (_remember(_processed, payload.key)) {
        NotificationUpdates.instance.add(payload);
        if (payload.isOrder) {
          unawaited(NotificationUpdates.instance
              .enrichOrder(payload)
              .catchError((Object e) {
            debugPrint('FCM missing order fields: $e');
          }));
        }
        getIt<NotificationCubit>().applyPush(payload);
        if (payload.kind == NotificationKind.chat) {
          final normalized = {
            for (final e in payload.data.entries)
              e.key.toLowerCase().replaceAll('_', ''): e.value
          };
          normalized['message'] ??= payload.body;
          normalized['fromusername'] ??= payload.title;
          normalized['date'] ??= payload.sentAt.toIso8601String();
          for (final field in ['viewed', 'isclosed']) {
            normalized[field] =
                '${normalized[field]}'.toLowerCase() == 'true' ||
                    normalized[field] == '1';
          }
          ChatEvents.instance.add(ReceiveMessageData.fromJson(normalized));
        } else if (payload.kind == NotificationKind.chatStatus) {
          getIt<ProviderChatCubit>().applyChatStatus({
            for (final e in payload.data.entries)
              e.key.toLowerCase().replaceAll('_', ''): e.value
          });
        }
        if (!opened) _displayWhenReady(payload, false);
      }
      // A click still navigates when this message was already applied in foreground.
      if (opened && _remember(_opened, payload.key)) {
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
      final session = _session;
      unawaited(NotificationModule.instance.dialogService.dismiss().then((_) {
        if (session == _session) {
          NotificationModule.instance.navigationService.openPayload(payload);
        }
      }));
    } else if (payload.kind == NotificationKind.chat) {
      final active =
          ChatEvents.instance.activeChatUserId == payload.integer('fromuser') &&
              ChatEvents.instance.activeChatUserType ==
                  payload.integer('fromusertype');
      if (!active) unawaited(AudioService.instance.playMessageSoundOnce());
    } else if (payload.kind == NotificationKind.serviceRequest) {
      final id = payload.integer('requestId');
      if (id == null || _serviceRequestSounds.add(id)) {
        if (_serviceRequestSounds.length > 500) {
          _serviceRequestSounds.remove(_serviceRequestSounds.first);
        }
        unawaited(AudioService.instance.playMessageSoundOnce());
      }
    } else if (payload.isOrder) {
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
    await NotificationModule.instance.dialogService.dismiss();
    await _tokenSubscription?.cancel();
    await _messageSubscription?.cancel();
    await _openSubscription?.cancel();
    _tokenSubscription = null;
    _messageSubscription = _openSubscription = null;
    NotificationUpdates.instance.reset();
    ServiceOfferOptions.instance.reset();
    if (getIt.isRegistered<ServiceRequestsCubit>()) {
      getIt<ServiceRequestsCubit>().reset();
    }
    if (getIt.isRegistered<NotificationCubit>()) {
      getIt<NotificationCubit>().reset();
    }
    if (getIt.isRegistered<ProviderChatCubit>()) {
      getIt<ProviderChatCubit>().reset();
    }
    await AudioService.instance.stopNotificationSound();
    await AuthLocalStorage.deleteFcmToken();
  }
}
