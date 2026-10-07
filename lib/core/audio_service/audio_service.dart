import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _messagePlayer = AudioPlayer();

  Future<void> playMessageSoundOnce() async {
    try {
      await _messagePlayer.setReleaseMode(ReleaseMode.release);
      await _messagePlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      debugPrint('Message sound: $e');
    }
  }

  Future<void> startNotificationSound() async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(
        AssetSource("sounds/notification.mp3"),
      );
    } catch (e) {
      if (kDebugMode) {
        print("AudioService note (sound playback): $e");
      }
    }
  }

  Future<void> stopNotificationSound() async {
    try {
      await _messagePlayer.stop();
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.release);
    } catch (_) {}
  }
}
