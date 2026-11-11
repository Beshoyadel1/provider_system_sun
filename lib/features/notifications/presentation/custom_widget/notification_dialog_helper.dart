import 'package:flutter/material.dart';
import '../../../../../../features/notifications/presentation/pages/notification_dialog/notification_dialog.dart';

class NotificationDialogHelper {
  static DialogRoute<bool> createRoute({
    required BuildContext context,
    required String title,
    required String subTitle,
    bool barrierDismissible = false,
  }) {
    return DialogRoute<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return NotificationDialog(
          title: title,
          subTitle: subTitle,
          onClose: () => Navigator.of(context).pop(false),
          onView: () => Navigator.of(context).pop(true),
        );
      },
    );
  }
}
