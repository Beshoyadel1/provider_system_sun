import 'dart:convert';
import 'dart:typed_data';
import 'last_message_model.dart';

class MessageModel {
  final int? userId;
  final int? userType;
  final String? userName;
  final int? unViewedMessagesCount;
  final LastMessageModel? lastMessage;
  final Uint8List? userImage;

  MessageModel({
    this.userId,
    this.userType,
    this.userName,
    this.unViewedMessagesCount,
    this.lastMessage,
    this.userImage,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final map = <String, dynamic>{};
    json.forEach((k, v) => map[k.toString().toLowerCase()] = v);

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    Uint8List? parseImage(dynamic value) {
      if (value == null) return null;
      if (value is Uint8List) return value;
      if (value is List) {
        try {
          return Uint8List.fromList(value.cast<int>());
        } catch (_) {
          return null;
        }
      }
      final str = value.toString().trim();
      if (str.isEmpty) return null;
      try {
        return base64Decode(str);
      } catch (_) {
        return null;
      }
    }

    final userId = parseInt(map['userid'] ?? map['id']);
    final userType = parseInt(map['usertype'] ?? map['type']);
    final userName = (map['username'] ?? map['name'] ?? "").toString();
    final unViewedCount = parseInt(map['unviewedmessagescount'] ?? map['unviewedcount']);

    dynamic lastMsgRaw = map['lastmessage'];
    LastMessageModel? lastMessage;
    if (lastMsgRaw is Map) {
      lastMessage = LastMessageModel.fromJson(Map<String, dynamic>.from(lastMsgRaw));
    } else if (lastMsgRaw is String && lastMsgRaw.isNotEmpty) {
      try {
        lastMessage = LastMessageModel.fromJson(Map<String, dynamic>.from(jsonDecode(lastMsgRaw)));
      } catch (_) {}
    }

    return MessageModel(
      userId: userId,
      userType: userType,
      userName: userName,
      unViewedMessagesCount: unViewedCount,
      lastMessage: lastMessage,
      userImage: parseImage(map['userimage'] ?? map['image']),
    );
  }
}