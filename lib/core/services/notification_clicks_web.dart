import 'dart:convert';
import 'dart:js_interop';

@JS('registerNotificationClickHandler')
external void _register(JSFunction? callback);

@JS('registerNotificationMessageHandler')
external void _registerMessage(JSFunction? callback);

void Function() listenForNotificationClicks(
    void Function(Map<String, dynamic>) onClick,
    {void Function(Map<String, dynamic>)? onMessage}) {
  JSFunction callback(void Function(Map<String, dynamic>) handler) =>
      ((JSString raw) {
        try {
          final payload = jsonDecode(raw.toDart);
          if (payload is Map) handler(Map<String, dynamic>.from(payload));
        } catch (_) {}
      }).toJS;
  _register(callback(onClick));
  _registerMessage(onMessage == null ? null : callback(onMessage));
  return () {
    _register(null);
    _registerMessage(null);
  };
}
