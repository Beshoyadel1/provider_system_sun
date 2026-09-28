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

  bool get isShowing => _isShowing;

  Future<void> show({
    required String title,
    required String subtitle,
    required Future<void> Function() onView,
  }) async {
    final navContext = navigatorKey.currentContext;

    if (navContext == null || !navContext.mounted) {
      return;
    }

    await _audio.play();

    if (_isShowing) {
      navigatorKey.currentState?.pop();

      _isShowing = false;

      await Future.delayed(
        const Duration(milliseconds: 150),
      );
    }

    final activeContext = navigatorKey.currentContext;
    if (activeContext == null || !activeContext.mounted) {
      return;
    }

    _isShowing = true;

    await NotificationDialogHelper.show(
      context: activeContext,
      title: title,
      subTitle: subtitle,
      onClose: () async {
        await _audio.stop();

        _isShowing = false;

        navigatorKey.currentState?.pop();
      },
      onView: () async {
        await _audio.stop();

        _isShowing = false;

        navigatorKey.currentState?.pop();

        // استدعاء الـ Action القادم من الـ Handler
        await onView();
      },
    );

    _isShowing = false;
  }
}
