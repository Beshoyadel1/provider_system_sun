import 'dart:convert';
import 'dart:typed_data';
import 'message_item_model.dart';

class ChatDetailsModel {
  final int? toUser;
  final int? toUserType;
  final String? userName;
  final Uint8List? image;
  final List<MessageItemModel>? messages;

  ChatDetailsModel({
    this.toUser,
    this.toUserType,
    this.userName,
    this.image,
    this.messages,
  });

  factory ChatDetailsModel.fromJson(Map<String, dynamic> json) {
    final map = <String, dynamic>{};
    json.forEach((k, v) => map[k.toString().toLowerCase()] = v);

    Uint8List? parsedImage;
    final imageRaw = map['image'];
    if (imageRaw is Uint8List) {
      parsedImage = imageRaw;
    } else if (imageRaw is List) {
      try {
        parsedImage = Uint8List.fromList(imageRaw.cast<int>());
      } catch (_) {}
    } else if (imageRaw != null && imageRaw.toString().trim().isNotEmpty) {
      try {
        parsedImage = base64Decode(imageRaw.toString().trim());
      } catch (_) {}
    }

    final rawMessages = map['messages'];

    return ChatDetailsModel(
      toUser: _toInt(map['touser'] ?? map['userid']),
      toUserType: _toInt(map['tousertype'] ?? map['usertype']),
      userName: (map['username'] ?? map['name'] ?? '').toString(),
      image: parsedImage,
      messages: rawMessages is List
          ? rawMessages
              .whereType<Map>()
              .map((e) => MessageItemModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <MessageItemModel>[],
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}