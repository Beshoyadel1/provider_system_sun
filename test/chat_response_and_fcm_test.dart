import 'package:flutter_test/flutter_test.dart';
import 'package:sun_web_system/features/technical_support/data/model/get_user_chats_model/message_model.dart';
import 'package:sun_web_system/features/technical_support/data/model/get_work_team_chat_repository/work_team_user_model.dart';
import 'package:sun_web_system/features/technical_support/data/model/get_chat_messages_model/chat_details_model.dart';
import 'package:sun_web_system/features/technical_support/data/request/get_work_team_chat_request/get_work_team_chat_request.dart';
import 'package:sun_web_system/features/notifications/data/model/receive_message_notification_model/receive_message_notification_model.dart';

void main() {
  group('Chat Models Deserialization and Request Tests', () {
    test('MessageModel parses GetUserChats response with PascalCase and UPPERCASE keys', () {
      final json = {
        "UserId": 42,
        "UserType": 1,
        "UserName": "Engineer Mohamed",
        "UnViewedMessagesCount": 3,
        "UserImage": null,
        "LastMessage": {
          "ID": 1001,
          "FROMUSER": 42,
          "TOUSER": 5,
          "FROMUSERTYPE": 1,
          "TOUSERTYPE": 4,
          "MESSAGE": "Hello, need assistance with order 55",
          "DATE": "2026-09-28T00:15:30.0000000Z",
          "VIEWED": false,
          "ISCLOSED": false,
          "HARAGEID": 0,
          "ORDERID": 55,
        }
      };

      final model = MessageModel.fromJson(json);

      expect(model.userId, equals(42));
      expect(model.userType, equals(1));
      expect(model.userName, equals("Engineer Mohamed"));
      expect(model.unViewedMessagesCount, equals(3));
      expect(model.lastMessage, isNotNull);
      expect(model.lastMessage!.id, equals(1001));
      expect(model.lastMessage!.fromUser, equals(42));
      expect(model.lastMessage!.toUser, equals(5));
      expect(model.lastMessage!.message, equals("Hello, need assistance with order 55"));
      expect(model.lastMessage!.viewed, equals(false));
      expect(model.lastMessage!.orderId, equals(55));
      expect(model.lastMessage!.date, isNotNull);
      expect(model.lastMessage!.date!.year, equals(2026));
    });

    test('WorkTeamUserModel parses GetWorkTeamChat response with UPPERCASE keys', () {
      final json = {
        "USERID": 10,
        "USERTYPE": 3,
        "NAME": "Technician Ali",
        "JOBNAME": "Field Technician",
        "LATINNAME": "Ali Tech",
        "LATINJOBNAME": "Field Tech",
        "IMAGE": null,
      };

      final model = WorkTeamUserModel.fromJson(json);

      expect(model.userId, equals(10));
      expect(model.userType, equals(3));
      expect(model.name, equals("Technician Ali"));
      expect(model.jobName, equals("Field Technician"));
      expect(model.latinName, equals("Ali Tech"));
      expect(model.latinJobName, equals("Field Tech"));
    });

    test('ChatDetailsModel and MessageItemModel parse GetChatMessages response', () {
      final json = {
        "TOUSER": 42,
        "TOUSERTYPE": 1,
        "UserName": "Engineer Mohamed",
        "Image": null,
        "Messages": [
          {
            "ID": 501,
            "FROMUSER": 42,
            "TOUSER": 5,
            "MESSAGE": "Can you check my order?",
            "DATE": "2026-09-28T00:10:00.0000000Z",
            "VIEWED": true,
            "FROMUSERNAME": "Engineer Mohamed",
            "FROMUSERTYPE": 1,
            "TOUSERTYPE": 4,
          },
          {
            "ID": 502,
            "FROMUSER": 5,
            "TOUSER": 42,
            "MESSAGE": "Checking it now!",
            "DATE": "2026-09-28T00:11:00.0000000Z",
            "VIEWED": false,
            "FROMUSERNAME": "Provider Support",
            "FROMUSERTYPE": 4,
            "TOUSERTYPE": 1,
          }
        ]
      };

      final chatDetails = ChatDetailsModel.fromJson(json);

      expect(chatDetails.toUser, equals(42));
      expect(chatDetails.toUserType, equals(1));
      expect(chatDetails.userName, equals("Engineer Mohamed"));
      expect(chatDetails.messages, isNotNull);
      expect(chatDetails.messages!.length, equals(2));

      final firstMsg = chatDetails.messages![0];
      expect(firstMsg.id, equals(501));
      expect(firstMsg.fromUser, equals(42));
      expect(firstMsg.toUser, equals(5));
      expect(firstMsg.message, equals("Can you check my order?"));
      expect(firstMsg.viewed, equals(true));
      expect(firstMsg.fromUserName, equals("Engineer Mohamed"));
      expect(firstMsg.date, isNotNull);

      final secondMsg = chatDetails.messages![1];
      expect(secondMsg.id, equals(502));
      expect(secondMsg.fromUser, equals(5));
      expect(secondMsg.toUser, equals(42));
      expect(secondMsg.message, equals("Checking it now!"));
      expect(secondMsg.viewed, equals(false));
    });

    test('GetWorkTeamChatRequest includes both userId and user query parameters', () {
      final request = GetWorkTeamChatRequest(userId: 15, userType: 4);
      final json = request.toJson();

      expect(json['userId'], equals(15));
      expect(json['user'], equals(15));
      expect(json['userType'], equals(4));
    });

    test('ReceiveMessageNotificationModel parses FCM Chat notification with ISO date', () {
      final fcmPayload = {
        "title": "Engineer Mohamed",
        "body": "Checking in",
        "data": {
          "type": "Chat",
          "id": "777",
          "fromuser": "42",
          "touser": "5",
          "message": "Checking in",
          "date": "2026-09-28T00:20:00.0000000Z",
          "viewed": "false",
          "fromusertype": "1",
          "tousertype": "4",
          "fromusername": "Engineer Mohamed",
        }
      };

      final model = ReceiveMessageNotificationModel.fromJson(fcmPayload);

      expect(model.userId, equals(5));
      expect(model.userType, equals(4));
      expect(model.data?.data?.id, equals("777"));
      expect(model.data?.data?.fromUser, equals("42"));
      expect(model.data?.data?.toUser, equals("5"));
      expect(model.data?.data?.message, equals("Checking in"));
      expect(model.data?.data?.fromUserName, equals("Engineer Mohamed"));
      expect(model.data?.data?.date, equals("2026-09-28T00:20:00.0000000Z"));
    });
  });
}
