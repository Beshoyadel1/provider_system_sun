import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import 'notification_sound_stub.dart'
    if (dart.library.js_interop) 'notification_sound_web.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  AudioPlayer? _player;
  AudioPlayer? _messagePlayer;
  int _orderVersion = 0;
  int _messageVersion = 0;

  Future<void> playMessageSoundOnce() async {
    final version = ++_messageVersion;
    try {
      if (kIsWeb) {
        await playWebNotificationSound(loop: false);
        return;
      }
      final player = _messagePlayer ??= AudioPlayer();
      await player.setReleaseMode(ReleaseMode.release);
      if (version != _messageVersion) return;
      await player.play(AssetSource('sounds/notification.mp3'));
    } catch (_) {}
  }

  Future<void> startNotificationSound() async {
    final version = ++_orderVersion;
    try {
      if (kIsWeb) {
        await playWebNotificationSound(loop: true);
        return;
      }
      final player = _player ??= AudioPlayer();
      await player.stop();
      await player.setReleaseMode(ReleaseMode.loop);
      if (version != _orderVersion) return;
      await player.play(AssetSource('sounds/notification.mp3'));
    } catch (_) {}
  }

  Future<void> stopOrderSound() async {
    _orderVersion++;
    try {
      if (kIsWeb) {
        stopWebNotificationSound(loop: true);
      } else {
        await _player?.stop();
      }
    } catch (_) {}
  }

  Future<void> stopNotificationSound() async {
    _messageVersion++;
    final orderStop = stopOrderSound();
    try {
      if (kIsWeb) {
        stopWebNotificationSound(loop: false);
      } else {
        await _messagePlayer?.stop();
      }
    } catch (_) {}
    await orderStop;
  }
}
