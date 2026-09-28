import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import 'package:sun_web_system/core/api/dio_function/dio_controller.dart';
import 'package:sun_web_system/core/services/browser_notification.dart';
import 'package:sun_web_system/core/theming/auth_local_storage.dart';
import 'package:sun_web_system/features/notifications/presentation/bloc/notification_cubit/notification_cubit.dart';
import 'package:sun_web_system/features/notifications/presentation/module/notification_module/notification_module.dart';
import 'package:sun_web_system/main.dart';

/// Top-level background message handler for FCM
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('FCM: Handling a background message: ${message.messageId}');
  }
}

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Platforms supporting Firebase Messaging natively or via Web Service Worker.
  static bool get isSupported {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
      default:
        return false;
    }
  }

  /// Initializes FCM listeners and token lifecycle.
  Future<void> init() async {
    if (!isSupported) {
      if (kDebugMode) {
        print('FCM: Not supported on platform ($defaultTargetPlatform). Skipping init.');
      }
      return;
    }

    if (_isInitialized) return;

    try {
      final messaging = FirebaseMessaging.instance;

      // 1. Request user permission for notifications
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print('FCM: User notification authorization status: ${settings.authorizationStatus}');
      }

      // 2. Fetch FCM Token
      _fcmToken = await getToken(vapidKey: FcmConfig.webVapidKey);
      if (kDebugMode) {
        print('FCM: Initial Token: $_fcmToken');
      }
      if (_fcmToken != null && _fcmToken!.isNotEmpty) {
        await _syncTokenIfUserAvailable(_fcmToken!);
      }

      // 3. Listen to token refresh
      try {
        messaging.onTokenRefresh.listen((newToken) {
          _fcmToken = newToken;
          if (kDebugMode) {
            print('FCM: Token refreshed: $newToken');
          }
          _syncTokenIfUserAvailable(newToken);
        });
      } catch (e) {
        if (kDebugMode) {
          print('FCM: Token refresh listener setup note: $e');
        }
      }

      // 4. Foreground message listener
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('FCM: Foreground message received: ${message.data}');
        }
        _handleRemoteMessage(message);
      });

      // 5. Message opened app listener
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('FCM: Message opened app: ${message.data}');
        }
        _handleRemoteMessage(message);
      });

      _isInitialized = true;
    } catch (e, stack) {
      if (kDebugMode) {
        print('FCM: Initialization error: $e\n$stack');
      }
    }
  }

  Future<String>? _pendingGetToken;

  /// Retrieves the current device/browser FCM registration token.
  Future<String> getToken({String? vapidKey}) async {
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
              final newSettings = await FirebaseMessaging.instance.requestPermission();
              if (kDebugMode) {
                print('FCM Web: Requested notification permission => ${newSettings.authorizationStatus}');
              }
            } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
              if (kDebugMode) {
                print('FCM Web: Notification permission is DENIED by the user/browser.');
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
        print('FCM: Platform $defaultTargetPlatform does not support native Firebase Messaging. Using fallback persistent tokens.');
      }
    }

    // 2. Return cached memory token if available
    if (_fcmToken != null && _fcmToken!.trim().isNotEmpty) {
      return _fcmToken!;
    }

    // 3. Return locally stored FCM token if available
    try {
      final savedToken = await AuthLocalStorage.getFcmToken();
      if (savedToken != null && savedToken.trim().isNotEmpty) {
        _fcmToken = savedToken.trim();
        return _fcmToken!;
      }
    } catch (_) {}

    // 4. Return user model token if available
    final user = await AuthLocalStorage.getUser();
    if (user != null &&
        user.fcmToken != null &&
        user.fcmToken!.trim().isNotEmpty) {
      _fcmToken = user.fcmToken!.trim();
      try {
        await AuthLocalStorage.saveFcmToken(_fcmToken!);
      } catch (_) {}
      return _fcmToken!;
    }

    // 5. Generate and persist fallback token for desktop / testing
    final fallbackToken = await _getOrCreateFallbackToken();
    _fcmToken = fallbackToken;
    return fallbackToken;
  }

  Future<String> _getOrCreateFallbackToken() async {
    try {
      final saved = await AuthLocalStorage.getFcmToken();
      if (saved != null && saved.trim().isNotEmpty) {
        return saved.trim();
      }
    } catch (_) {}

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = (Random().nextInt(900000) + 100000).toString();
    final platformTag = kIsWeb ? 'web' : defaultTargetPlatform.name.toLowerCase();
    final generated = 'fcm_${platformTag}_${timestamp}_$randomSuffix';
    try {
      await AuthLocalStorage.saveFcmToken(generated);
    } catch (_) {}
    return generated;
  }

  /// Manually trigger token sync for the current logged-in provider.
  Future<void> syncCurrentToken({int? userId, int? userType}) async {
    final user = await AuthLocalStorage.getUser();
    final effectiveUserId = userId ?? user?.userid;
    final effectiveUserType = userType ?? user?.type ?? UserType.providerUser;

    if (effectiveUserId != null && effectiveUserId > 0) {
      final token = await getToken(vapidKey: FcmConfig.webVapidKey);
      if (token.isNotEmpty) {
        await _syncTokenWithBackend(
          userId: effectiveUserId,
          userType: effectiveUserType,
          token: token,
        );
      }
    }
  }

  Future<void> _syncTokenIfUserAvailable(String token) async {
    if (token.trim().isEmpty) {
      return;
    }
    final user = await AuthLocalStorage.getUser();
    if (user != null && user.userid != null && user.userid! > 0) {
      await _syncTokenWithBackend(
        userId: user.userid!,
        userType: user.type ?? UserType.providerUser,
        token: token,
      );
    }
  }

  Future<void> _syncTokenWithBackend({
    required int userId,
    required int userType,
    required String token,
  }) async {
    final cleanToken = token.trim();
    if (cleanToken.isEmpty) {
      if (kDebugMode) {
        print('FCM: Skipping backend sync for empty token');
      }
      return;
    }

    try {
      final payload = {
        'userId': userId,
        'UserId': userId,
        'userType': userType,
        'UserType': userType,
        'fcmToken': cleanToken,
        'FcmToken': cleanToken,
        'FCMTOKEN': cleanToken,
      };
      await Network.postDataWithBodyAndParams(
        payload,
        payload,
        ApiLink.updateFcmToken,
      );
      await AuthLocalStorage.saveFcmToken(cleanToken);
      if (kDebugMode) {
        print('FCM: Successfully synced token with backend for user $userId (type $userType)');
      }

      // Automatically subscribe to topics for Provider if real FCM token
      if (isSupported && !cleanToken.startsWith('fcm_')) {
        await subscribeToTopic('provider', userType: userType);
        await subscribeToTopic('all', userType: userType);
      }
    } catch (e) {
      if (kDebugMode) {
        print('FCM: Failed to sync token with backend: $e');
      }
    }
  }

  /// Subscribes the current device/token to a specific topic
  Future<void> subscribeToTopic(String topic, {int? userType}) async {
    final token = _fcmToken ?? await AuthLocalStorage.getFcmToken();
    if (token == null || token.isEmpty || token.startsWith('fcm_')) {
      return;
    }

    // 1. Native mobile/desktop subscription
    if (!kIsWeb) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
        if (kDebugMode) {
          print('FCM: Natively subscribed to topic: $topic');
        }
      } catch (e) {
        if (kDebugMode) {
          print('FCM: Native subscribe error note: $e');
        }
      }
    }

    // 2. Server-side subscription via backend endpoint (supports Web and Mobile via FirebaseAdmin)
    try {
      final body = jsonEncode({
        'fcmToken': token,
        'topic': topic,
        if (userType != null) 'userType': userType,
      });
      await Network.postDataWithBody(body, ApiLink.subscribeToTopic);
      if (kDebugMode) {
        print('FCM: Server-side subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('FCM: Server-side topic subscription note: $e');
      }
    }
  }

  void _handleRemoteMessage(RemoteMessage message) {
    try {
      final data = Map<String, dynamic>.from(message.data);
      final rawType = (data['type'] ?? data['eventType'] ?? '').toString();
      final normType = rawType.toLowerCase().replaceAll('_', '');

      // Extract general notification info
      final title = message.notification?.title ??
          data['title'] ??
          data['latintitle'] ??
          data['ar_title'] ??
          data['en_title'] ??
          data['fromusername'] ??
          data['sender'] ??
          'إشعار جديد';
      final body = message.notification?.body ??
          data['body'] ??
          data['description'] ??
          data['latindesc'] ??
          data['ar_body'] ??
          data['en_body'] ??
          data['message'] ??
          data['text'] ??
          '';

      if (kDebugMode) {
        print('FCM: Remote message received. RawType: $rawType, Title: $title, Body: $body');
      }

      // 1. Show native browser notification on Web if permission is active
      try {
        showBrowserNotification(title.toString(), body.toString());
      } catch (_) {}

      // 2. Prepare adapted payload for NotificationModule handlers
      final adaptedPayload = <String, dynamic>{
        'type': rawType,
        'title': title.toString(),
        'body': body.toString(),
        'data': data,
        ...data,
      };

      // 3. Dispatch to appropriate handler
      final isChatPayload = normType == 'chat' ||
          normType == 'receivemessage' ||
          data.containsKey('fromuser') ||
          data.containsKey('fromUser');

      final isNewOrderPayload = normType == 'neworder' ||
          data.containsKey('orderinfo') ||
          data.containsKey('orderInfo');

      final isUpdateOrderStatusPayload = normType == 'updateorderstatus' ||
          normType == 'orderstatus';

      if (isNewOrderPayload) {
        NotificationModule.instance.newOrderHandler.handle([adaptedPayload]);
      } else if (isUpdateOrderStatusPayload) {
        NotificationModule.instance.updateOrderStatusHandler.handle([adaptedPayload]);
        NotificationModule.instance.receiveNotificationHandler.handle([adaptedPayload]);
      } else if (isChatPayload) {
        NotificationModule.instance.receiveMessageHandler.handle([adaptedPayload]);
      } else {
        NotificationModule.instance.receiveNotificationHandler.handle([adaptedPayload]);
      }

      // 4. Refresh global NotificationCubit if app is mounted
      try {
        final ctx = navigatorKey.currentContext;
        if (ctx != null) {
          BlocProvider.of<NotificationCubit>(ctx, listen: false).getUserNotification();
        }
      } catch (_) {}
    } catch (e, stack) {
      if (kDebugMode) {
        print('FCM: Error processing message: $e\n$stack');
      }
    }
  }

  /// Disconnects listeners and resets local state on logout.
  Future<void> disconnect() async {
    _isInitialized = false;
    _fcmToken = null;
    try {
      await AuthLocalStorage.deleteFcmToken();
    } catch (_) {}
  }
}
