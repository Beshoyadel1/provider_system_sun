class MessageItemModel {
  final int id;
  final int fromUser;
  final int toUser;
  final String message;
  final DateTime? date;
  final bool viewed;

  MessageItemModel({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.message,
    this.date,
    required this.viewed,
  });

  factory MessageItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return MessageItemModel(
      id: _toInt(json['id']),
      fromUser: _toInt(json['fromuser']),
      toUser: _toInt(json['touser']),
      message: json['message']?.toString() ?? '',
      date: _parseDate(json['date']),
      viewed: _toBool(json['viewed']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;

    return value
        ?.toString()
        .toLowerCase()
        .trim() ==
        'true';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    final text = value.toString();

    if (text.isEmpty) return null;

    return DateTime.tryParse(text);
  }
}