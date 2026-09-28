import 'package:flutter/foundation.dart';
import '../../../../../../features/notifications/data/datasource/parsers/receive_notification_parser/receive_notification_parser.dart';
import '../../../../../../features/notifications/domain/repository/notification_repository/notification_repository.dart';
import '../../../../../../features/notifications/presentation/services/dialog_service/dialog_service.dart';
import '../../../../../../features/notifications/presentation/services/navigation_service/navigation_service.dart';
import '../../../../../../main.dart';

class ReceiveNotificationHandler {
  ReceiveNotificationHandler({
    required ReceiveNotificationParser parser,
    required NotificationRepository repository,
    required NotificationDialogService dialogService,
    required NotificationNavigationService navigationService,
  })  : _parser = parser,
        _repository = repository,
        _dialogService = dialogService,
        _navigationService = navigationService;

  final ReceiveNotificationParser _parser;
  final NotificationRepository _repository;
  final NotificationDialogService _dialogService;
  final NotificationNavigationService _navigationService;


  Future<void> handle(
      List<Object?>? arguments,
      ) async {
    try {
      final currentUser = await _repository.getCurrentUser();

      if (currentUser == null) {
        return;
      }

      final userType = _parser.getUserType(arguments);

      if (userType != null &&
          userType != 0 &&
          userType != currentUser.type) {
        return;
      }

      final userId = _parser.getUserId(arguments);

      if (userId != null &&
          userId != 0 &&
          userId != currentUser.userid) {
        return;
      }

      final model = _parser.parse(arguments);

      if (model == null) {
        return;
      }

      final currentCtx = navigatorKey.currentContext;
      final title = (currentCtx != null && currentCtx.mounted)
          ? model.getTitle(currentCtx)
          : (model.title ?? model.latinTitle ?? "إشعار جديد");
      final subtitle = (currentCtx != null && currentCtx.mounted)
          ? model.getDescription(currentCtx)
          : (model.description ?? model.latinDesc ?? "");
      final combined = "$title $subtitle".toLowerCase();
      final isChat = combined.contains("chat") ||
          combined.contains("رسالة") ||
          combined.contains("محادثة");

      await _dialogService.show(
        title: title.isNotEmpty ? title : "إشعار جديد",
        subtitle: subtitle,
        onView: () async {
          if (isChat) {
            _navigationService.openChat();
          } else {
            _navigationService.openDashboardOrders();
          }
        },
      );
    } catch (e, s) {
      debugPrint(
        "ReceiveNotification Error => $e",
      );

      debugPrintStack(
        stackTrace: s,
      );
    }
  }
}