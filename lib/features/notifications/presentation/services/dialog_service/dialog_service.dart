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
        navigation = navigationService ?? const NotificationNavigationService();

  final NotificationAudioService _audio;
  final NotificationNavigationService navigation;

  DialogRoute<bool>? _route;
  int _generation = 0;
  Future<void> _queue = Future.value();

  bool get isShowing => _route?.isActive == true;

  Future<void> show({
    required String title,
    required String subtitle,
    required Future<void> Function() onView,
  }) {
    final generation = _generation;
    _queue = _queue
        .then((_) => _show(
              title: title,
              subtitle: subtitle,
              onView: onView,
              generation: generation,
            ))
        .catchError((Object _) {});
    return _queue;
  }

  Future<void> dismiss() async {
    _generation++;
    final route = _route;
    if (route != null && route.isActive) {
      route.navigator?.removeRoute(route);
    }
  }

  Future<void> _show({
    required String title,
    required String subtitle,
    required Future<void> Function() onView,
    required int generation,
  }) async {
    final navigator = navigatorKey.currentState;
    if (generation != _generation || navigator == null || !navigator.mounted) {
      return;
    }
    final route = NotificationDialogHelper.createRoute(
      context: navigator.context,
      title: title,
      subTitle: subtitle,
    );
    _route = route;
    bool? shouldView;
    try {
      final result = navigator.push(route);
      _audio.play().ignore();
      shouldView = await result;
    } finally {
      _route = null;
      _audio.stop().ignore();
    }
    if (shouldView == true && generation == _generation) await onView();
  }
}
