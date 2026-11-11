import 'dart:convert';
import 'dart:js_interop';

@JS('listenForSunNotificationClicks')
external JSFunction _listen(JSFunction callback);

@JS('prepareSunFcmWorker')
external JSPromise<JSAny?> _prepareFcmWorker();

Future<void> prepareFcmWorker() async {
  await _prepareFcmWorker().toDart;
}

void Function() listenForNotificationClicks(
    void Function(Map<String, dynamic>) onClick,
    {void Function(Map<String, dynamic>)? onMessage}) {
  final stop = _listen(((JSString raw) {
    try {
      final payload = jsonDecode(raw.toDart);
      if (payload is! Map) return;
      final data = Map<String, dynamic>.from(payload);
      if (data['sunOpened'] == false) {
        onMessage?.call(data);
      } else {
        onClick(data);
      }
    } catch (_) {}
  }).toJS);
  return () => stop.callAsFunction();
}
