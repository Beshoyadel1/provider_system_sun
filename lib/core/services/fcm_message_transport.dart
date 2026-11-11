import 'package:firebase_messaging/firebase_messaging.dart';

/// Keeps the actual foreground/open listeners testable without a live account.
abstract class FcmMessageTransport {
  Stream<RemoteMessage> get messages;
  Stream<RemoteMessage> get openedMessages;
  Stream<String> get tokenRefresh;
  Future<RemoteMessage?> getInitialMessage();
}

class FirebaseMessageTransport implements FcmMessageTransport {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  Stream<RemoteMessage> get messages => FirebaseMessaging.onMessage;
  @override
  Stream<RemoteMessage> get openedMessages =>
      FirebaseMessaging.onMessageOpenedApp;
  @override
  Stream<String> get tokenRefresh => _messaging.onTokenRefresh;
  @override
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();
}
