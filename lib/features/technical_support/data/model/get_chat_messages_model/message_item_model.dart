import 'package:intl/intl.dart';

class MessageItemModel {
  final int id;
  final int fromUser;
  final int toUser;
  final String message;
  final DateTime? date;
  final bool viewed;
  final String? fromUserName;
  final int? fromUserType;
  final int? toUserType;

  MessageItemModel({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.message,
    this.date,
    required this.viewed,
    this.fromUserName,
    this.fromUserType,
    this.toUserType,
  });

  factory MessageItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final map = <String, dynamic>{};
    json.forEach((k, v) => map[k.toString().toLowerCase()] = v);

    return MessageItemModel(
      id: _toInt(map['id']),
      fromUser: _toInt(map['fromuser']),
      toUser: _toInt(map['touser']),
      message: map['message']?.toString() ?? '',
      date: _parseDate(map['date']),
      viewed: _toBool(map['viewed']),
      fromUserName: map['fromusername']?.toString(),
      fromUserType: _toIntOrNull(map['fromusertype']),
      toUserType: _toIntOrNull(map['tousertype']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _toIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    final str = value?.toString().toLowerCase().trim();
    return str == 'true' || str == '1';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    final text = value.toString().trim();
    if (text.isEmpty) return null;

    final parsedIso = DateTime.tryParse(text);
    if (parsedIso != null) return parsedIso;

    try {
      return DateFormat('MM/dd/yyyy HH:mm:ss').parse(text);
    } catch (_) {
      try {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(text);
      } catch (_) {
        return null;
      }
    }
  }
}