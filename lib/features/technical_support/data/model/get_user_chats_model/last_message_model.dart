class LastMessageModel {
  final int? id;
  final int? fromUser;
  final int? toUser;
  final int? fromUserType;
  final int? toUserType;
  final String? message;
  final DateTime? date;
  final bool? viewed;
  final bool? isClosed;
  final int? harageId;
  final int? orderId;

  LastMessageModel({
    this.id,
    this.fromUser,
    this.toUser,
    this.fromUserType,
    this.toUserType,
    this.message,
    this.date,
    this.viewed,
    this.isClosed,
    this.harageId,
    this.orderId,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    final map = <String, dynamic>{};
    json.forEach((k, v) => map[k.toString().toLowerCase()] = v);

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      final str = value.toString().toLowerCase().trim();
      return str == 'true' || str == '1';
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString());
    }

    return LastMessageModel(
      id: parseInt(map['id']) ?? 0,
      fromUser: parseInt(map['fromuser']) ?? 0,
      toUser: parseInt(map['touser']) ?? 0,
      fromUserType: parseInt(map['fromusertype']),
      toUserType: parseInt(map['tousertype']),
      message: (map['message'] ?? "").toString(),
      date: parseDate(map['date']),
      viewed: parseBool(map['viewed']) ?? false,
      isClosed: parseBool(map['isclosed']),
      harageId: parseInt(map['harageid']),
      orderId: parseInt(map['orderid']),
    );
  }
}
