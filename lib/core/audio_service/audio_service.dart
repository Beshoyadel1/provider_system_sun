import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _oneShotPlayer = AudioPlayer();

  Future<void> startNotificationSound() async {
    await _player.stop();

    await _player.setReleaseMode(ReleaseMode.loop);

    await _player.play(
      AssetSource("sounds/notification.mp3"),
    );
  }

  Future<void> stopNotificationSound() async {
    await _player.stop();

    await _player.setReleaseMode(ReleaseMode.release);
  }

  Future<void> playNotificationOnce() async {
    await _oneShotPlayer.setReleaseMode(ReleaseMode.release);
    await _oneShotPlayer.play(AssetSource('sounds/notification.mp3'));
  }
}
