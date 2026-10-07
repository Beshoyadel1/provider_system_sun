import 'package:flutter/material.dart';
import '../../../../../../features/notifications/presentation/custom_widget/notification_dialog_helper.dart';
import '../../../../../../features/notifications/presentation/services/navigation_service/navigation_service.dart';
import '../../../../../../features/notifications/presentation/services/notification_audio_service/notification_audio_service.dart';
import '../../../../../../main.dart';

class NotificationDialogService {
  BuildContext? get context => navigatorKey.currentContext;

  NotificationDialogService({
    NotificationAudioService? audioService,
    NotificationNavigationService? navigationService,
  })  : _audio = audioService ?? const NotificationAudioService(),
        navigation =
            navigationService ?? const NotificationNavigationService();

  final NotificationAudioService _audio;
  final NotificationNavigationService navigation;

  bool _isShowing = false;
  int _generation = 0;
  Future<void> _queue = Future.value();

  bool get isShowing => _isShowing;

  Future<void> show({
    required String title,
    required String subtitle,
    required Future<void> Function() onView,
  }) {
    final generation = _generation;
    _queue = _queue.then((_) => _show(
      title: title, subtitle: subtitle, onView: onView, generation: generation,
    )).catchError((Object error) { debugPrint('Notification dialog: $error'); });
    return _queue;
  }

  Future<void> dismiss() async {
    _generation++;
    if (_isShowing) {
      _isShowing = false;
      navigatorKey.currentState?.pop();
    }
    await _audio.stop();
  }

  Future<void> _show({
    required String title,
    required String subtitle,
    required Future<void> Function() onView,
    required int generation,
  }) async {
    if (generation != _generation) return;
    final navContext = navigatorKey.currentContext;

    if (navContext == null || !navContext.mounted) {
      return;
    }

    await _audio.play();

    final activeContext = navigatorKey.currentContext;
    if (generation != _generation || activeContext == null || !activeContext.mounted) {
      await _audio.stop();
      return;
    }

    _isShowing = true;

    await NotificationDialogHelper.show(
      context: activeContext,
      title: title,
      subTitle: subtitle,
      onClose: () async {
        await _audio.stop();
        if (generation != _generation) return;

        _isShowing = false;

        navigatorKey.currentState?.pop();
      },
      onView: () async {
        await _audio.stop();
        if (generation != _generation) return;

        _isShowing = false;

        navigatorKey.currentState?.pop();

        // استدعاء الـ Action القادم من الـ Handler
        await onView();
      },
    );

    _isShowing = false;
    await _audio.stop();
  }
}
