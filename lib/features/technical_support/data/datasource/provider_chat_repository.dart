import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/api/api_result.dart';
import '../../../../core/api/dio_function/api_constants.dart';
import '../../../../core/api/dio_function/dio_controller.dart';
import '../model/provider_chat_model.dart';
import '../../../notifications/data/model/notification_payload.dart';

class ProviderChatRepository {
  const ProviderChatRepository();

  static List<Map<String, dynamic>> _records(dynamic raw) {
    for (var depth = 0; depth < 8; depth++) {
      if (raw == null) return [];
      if (raw is String) {
        raw = jsonDecode(raw);
        continue;
      }
      if (raw is List) {
        return raw
            .whereType<Map>()
            .map((m) => Map<String, dynamic>.from(m))
            .toList();
      }
      if (raw is Map) {
        if (NotificationPayload.value(raw, 'success') == false ||
            NotificationPayload.value(raw, 'status') == false) {
          throw StateError(
              '${NotificationPayload.value(raw, 'message') ?? 'Could not load conversation'}');
        }
        if (NotificationPayload.value(raw, 'messages') is List) {
          return [Map<String, dynamic>.from(raw)];
        }
        raw = NotificationPayload.value(raw, 'data');
        continue;
      }
      break;
    }
    throw const FormatException('Invalid conversation response');
  }

  static List<ChatMessageModel> parseMessages(dynamic raw) {
    final result = <ChatMessageModel>[];
    for (final record in _records(raw)) {
      final messages = NotificationPayload.value(record, 'messages');
      if (messages is List) {
        result.addAll(messages.whereType<Map>().map(
            (m) => ChatMessageModel.fromJson(Map<String, dynamic>.from(m))));
      } else {
        result.add(ChatMessageModel.fromJson(record));
      }
    }
    return result;
  }

  /// Fetches all conversation summaries for the specified user.
  Future<List<GetAllMessagesModel>> getAllMessages({
    required int userId,
    required int userType,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'userId': userId,
        'userType': userType,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.getUserChats,
      );

      if ((response.statusCode ?? 500) >= 400) {
        throw StateError('Could not load conversation');
      }
      final responseData = response.data;
      if (responseData == null)
        throw const FormatException('Invalid conversation response');

      final rawList = _records(responseData);

      return rawList
          .whereType<Map>()
          .map((item) =>
              GetAllMessagesModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to load conversations');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fetches team members associated with this provider (and technicians/support).
  Future<List<WorkTeamMemberModel>> getWorkTeam({
    required int userId,
    required int userType,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'userId': userId,
        'user': userId,
        'userType': userType,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.getWorkTeamChat,
      );

      if ((response.statusCode ?? 500) >= 400) {
        throw StateError('Could not load conversation');
      }
      final responseData = response.data;
      if (responseData == null)
        throw const FormatException('Invalid conversation response');

      final rawList = _records(responseData);

      return rawList
          .whereType<Map>()
          .map((item) =>
              WorkTeamMemberModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to load work team');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fetches the recent conversation messages using the GetChatMessages endpoint.
  Future<List<ChatMessageModel>> getChatMessages({
    required int fromUserId,
    required int fromUserType,
    required int toUserId,
    required int toUserType,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'fromUserId': fromUserId,
        'fromUserType': fromUserType,
        'toUserId': toUserId,
        'toUserType': toUserType,
        'isClosed': false,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.getChatMessages,
      );

      if ((response.statusCode ?? 500) >= 400) {
        throw StateError('Could not load conversation');
      }
      final responseData = response.data;
      if (responseData == null)
        throw const FormatException('Invalid conversation response');

      return parseMessages(responseData);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to load chat messages');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fetches older messages for a conversation before the specified [date].
  Future<List<ChatMessageModel>> getOlderMessages({
    required int fromUser,
    required int fromUserType,
    required int toUser,
    required int toUserType,
    required String date,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'fromUser': fromUser,
        'fromUserType': fromUserType,
        'toUser': toUser,
        'toUserType': toUserType,
        'date': date,
        'isClosed': false,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.getOtherMessages,
      );

      if ((response.statusCode ?? 500) >= 400) {
        throw StateError('Could not load conversation');
      }
      final responseData = response.data;
      if (responseData == null)
        throw const FormatException('Invalid conversation response');

      return parseMessages(responseData);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to load older messages');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Sends a new chat message to the recipient.
  Future<dynamic> sendChatMessage({
    required SendChatMessageModel message,
  }) async {
    try {
      final bodyString = jsonEncode(message.toJson());
      final response = await Network.postDataWithBody(
        bodyString,
        ApiLink.sendMessage,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to send message');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Marks the conversation between users as viewed.
  Future<bool> makeChatViewed({
    required int fromUser,
    required int fromUserType,
    required int toUser,
    required int toUserType,
    int? orderId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'fromUser': fromUser,
        'fromUserType': fromUserType,
        'toUser': toUser,
        'toUserType': toUserType,
      };
      if (orderId != null && orderId > 0) {
        queryParams['orderId'] = orderId;
      }

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.makeChatViewed,
      );
      ApiResult.requireSuccess(response);
      return true;
    } catch (_) {
      return false;
    }
  }
}
