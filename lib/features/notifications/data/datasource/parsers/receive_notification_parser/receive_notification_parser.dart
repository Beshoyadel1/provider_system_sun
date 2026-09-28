import 'dart:convert';
import '../../../../../../features/notifications/data/datasource/parsers/root_parser/root_parser.dart';
import '../../../../../../features/notifications/data/model/receive_notification_model/receive_notification_model.dart';

class ReceiveNotificationParser {
  ReceiveNotificationParser({
    RootParser? rootParser,
  }) : _rootParser = rootParser ?? const RootParser();

  final RootParser _rootParser;

  ReceiveNotificationModel? parse(List<Object?>? arguments) {
    final root = _rootParser.parse(arguments);

    if (root == null) {
      return null;
    }

    try {
      // 1. Try old SignalR nested format: root["data"]["data"]["notification"]
      if (root.containsKey("data") && root["data"] is Map) {
        final notification =
            Map<String, dynamic>.from(root["data"] as Map<dynamic, dynamic>);
        if (notification.containsKey("data") && notification["data"] is Map) {
          final data =
              Map<String, dynamic>.from(notification["data"] as Map<dynamic, dynamic>);
          if (data.containsKey("notification")) {
            final raw = data["notification"];
            if (raw is String) {
              final decoded = jsonDecode(raw) as Map<String, dynamic>;
              return ReceiveNotificationModel.fromJson(decoded);
            } else if (raw is Map) {
              return ReceiveNotificationModel.fromJson(Map<String, dynamic>.from(raw));
            }
          }
        }
        return ReceiveNotificationModel.fromJson(notification);
      }

      // 2. Direct FCM payload
      return ReceiveNotificationModel.fromJson(root);
    } catch (_) {
      return ReceiveNotificationModel.fromJson(root);
    }
  }

  int? getUserId(List<Object?>? arguments) {
    final root = _rootParser.parse(arguments);
    if (root == null) return null;
    final map = <String, dynamic>{};
    root.forEach((k, v) => map[k.toString().toLowerCase()] = v);
    final val = map["userid"] ?? map["touserid"];
    return val != null ? int.tryParse(val.toString()) : null;
  }

  int? getUserType(List<Object?>? arguments) {
    final root = _rootParser.parse(arguments);
    if (root == null) return null;
    final map = <String, dynamic>{};
    root.forEach((k, v) => map[k.toString().toLowerCase()] = v);
    final val = map["usertype"] ?? map["tousertype"];
    return val != null ? int.tryParse(val.toString()) : null;
  }
}