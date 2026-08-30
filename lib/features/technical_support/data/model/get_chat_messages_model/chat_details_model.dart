import 'dart:convert';
import 'dart:typed_data';
import 'message_item_model.dart';

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

  factory ChatDetailsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    Uint8List? parsedImage;

    final imageString = json['image']?.toString();

    if (imageString != null &&
        imageString.isNotEmpty) {
      try {
        parsedImage = base64Decode(imageString);
      } catch (_) {
        parsedImage = null;
      }
    }

    final rawMessages = json['messages'];

    return ChatDetailsModel(
      toUser: _toInt(json['touser']),
      toUserType: _toInt(json['tousertype']),
      userName: json['userName']?.toString() ?? '',
      image: parsedImage,
      messages: rawMessages is List
          ? rawMessages
          .whereType<Map<String, dynamic>>()
          .map(
        MessageItemModel.fromJson,
      )
          .toList()
          : <MessageItemModel>[],
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
      value?.toString() ?? '',
    );
  }
}