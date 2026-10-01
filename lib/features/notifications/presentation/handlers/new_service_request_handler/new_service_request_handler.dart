import 'package:flutter/foundation.dart';

import '../../../../../../core/cubit/app_cubit/app_cubit.dart';
import '../../../../../../core/setup_git_it.dart';
import '../../../../../../core/theming/auth_local_storage.dart';
import '../../../../../../core/utilies/map_of_all_app.dart';
import '../../../../service_requests/presentation/cubit/service_requests_cubit.dart';
import '../../../data/datasource/parsers/new_service_request_parser/new_service_request_parser.dart';
import '../../services/notification_audio_service/notification_audio_service.dart';

class NewServiceRequestHandler {
  NewServiceRequestHandler({
    required NewServiceRequestParser parser,
    NotificationAudioService audioService = const NotificationAudioService(),
  })  : _parser = parser,
        _audioService = audioService;

  final NewServiceRequestParser _parser;
  final NotificationAudioService _audioService;

  Future<void> handle(List<Object?>? arguments) async {
    try {
      final notification = _parser.parse(arguments);
      if (notification == null) return;

      final user = await AuthLocalStorage.getUser();
      if (user == null || notification.userType != user.type) return;
      if (notification.userId != null &&
          notification.userId != 0 &&
          notification.userId != user.userid) {
        return;
      }

      final appCubit = getIt<AppCubit>();
      final pageIsOpen =
          appCubit.selectedPageIndex == PagesOfAllApp.serviceRequestsPageNumber;
      final requestsCubit = getIt<ServiceRequestsCubit>();
      final item = notification.item;

      if (item != null) {
        requestsCubit.addRealtimeRequest(item, pageIsOpen: pageIsOpen);
      } else {
        requestsCubit.notifyWithoutItem(pageIsOpen: pageIsOpen);
      }

      await _audioService.playOnce();
    } catch (error, stackTrace) {
      debugPrint('NewServiceRequest Error => $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
