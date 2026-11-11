import 'dart:js_interop';

@JS('playSunNotificationSound')
external JSPromise<JSAny?> _play(JSBoolean loop);

@JS('stopSunNotificationSound')
external void _stop(JSBoolean loop);

Future<void> playWebNotificationSound({required bool loop}) async {
  await _play(loop.toJS).toDart;
}

void stopWebNotificationSound({required bool loop}) => _stop(loop.toJS);
