import 'dart:convert';
import 'dart:js_interop';

@JS('registerNotificationClickHandler')
external void _register(JSFunction? callback);

void Function() listenForNotificationClicks(
    void Function(Map<String, dynamic>) onClick) {
  _register(((JSString raw) {
    try {
      final payload = jsonDecode(raw.toDart);
      if (payload is Map) onClick(Map<String, dynamic>.from(payload));
    } catch (_) {}
  }).toJS);
  return () => _register(null);
}
