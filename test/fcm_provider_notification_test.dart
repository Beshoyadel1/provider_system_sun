import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_web_system/features/notifications/data/datasource/parsers/new_order_parser/new_order_parser.dart';
import 'package:sun_web_system/features/notifications/data/datasource/parsers/receive_notification_parser/receive_notification_parser.dart';
import 'package:sun_web_system/features/notifications/data/datasource/parsers/update_order_status_parser/update_order_status_parser.dart';
import 'package:sun_web_system/features/notifications/data/datasource/parsers/receive_message_parser/receive_message_parser.dart';
import 'package:sun_web_system/features/notifications/data/model/receive_notification_model/receive_notification_model.dart';
import 'package:sun_web_system/features/notifications/data/model/get_user_new_notification_model/get_user_new_notification_model.dart';

void main() {
  group('Provider FCM Payload Parsing Tests', () {
    test('NewOrderNotificationsModel parses FCM v1 flat payload with JSON string orderInfo', () {
      final fcmPayload = {
        'type': 'NewOrder',
        'orderId': '101',
        'title': 'طلب جديد',
        'body': 'لديك طلب جديد رقم 101',
        'orderInfo': jsonEncode({
          'ID': 101,
          'USERID': 5,
          'USERTYPE': 1,
          'ORDERSTATUS': 1,
          'ORDERDATE': '2026-09-27T20:00:00Z',
          'TOTALPRICE': 250.75,
        }),
      };

      final parser = NewOrderParser();
      final model = parser.parse([fcmPayload]);

      expect(model, isNotNull);
      expect(model!.data, isNotNull);
      expect(model.data!.orderId, equals(101));
      expect(model.data!.orderInfo, isNotNull);
      expect(model.data!.orderInfo!.id, equals(101));
      expect(model.data!.orderInfo!.userId, equals(5));
      expect(model.data!.orderInfo!.totalPrice, equals(250.75));
    });

    test('NewOrderNotificationsModel parses nested SignalR style payload', () {
      final signalRPayload = {
        'userId': 4,
        'userType': 4,
        'data': {
          'type': 'NewOrder',
          'orderId': 202,
          'orderInfo': {
            'ID': 202,
            'USERID': 8,
            'USERTYPE': 2,
            'ORDERSTATUS': 2,
            'TOTALPRICE': 500.0,
          },
        },
      };

      final parser = NewOrderParser();
      final model = parser.parse([signalRPayload]);

      expect(model, isNotNull);
      expect(model!.data, isNotNull);
      expect(model.data!.orderId, equals(202));
      expect(model.data!.orderInfo?.id, equals(202));
      expect(model.data!.orderInfo?.totalPrice, equals(500.0));
    });

    test('UpdateOrderStatusModelNotification parses FCM flat payload', () {
      final fcmPayload = {
        'type': 'UpdateOrderStatus',
        'orderId': '303',
        'status': '4',
        'title': 'تحديث الطلب',
        'body': 'تم تغيير حالة الطلب رقم 303',
        'toUserId': '12',
        'toUserType': '4',
      };

      final parser = UpdateOrderStatusParser();
      final model = parser.parse([fcmPayload]);

      expect(model, isNotNull);
      expect(model!.userId, equals(12));
      expect(model.userType, equals(4));
      expect(model.data?.data?.orderId, equals('303'));
      expect(model.data?.data?.status, equals('4'));
    });

    test('UpdateOrderStatusModelNotification parses SignalR nested payload', () {
      final nestedPayload = {
        'userId': 12,
        'userType': 4,
        'data': {
          'title': 'Order Updated',
          'body': 'Status is now in progress',
          'data': {
            'orderId': 404,
            'status': 3,
          },
        },
      };

      final parser = UpdateOrderStatusParser();
      final model = parser.parse([nestedPayload]);

      expect(model, isNotNull);
      expect(model!.userId, equals(12));
      expect(model.userType, equals(4));
      expect(model.data?.data?.orderId, equals('404'));
      expect(model.data?.data?.status, equals('3'));
    });

    test('ReceiveNotificationModel parses case-insensitive and stringified types', () {
      final payload = {
        'notificationid': '505',
        'title': 'إشعار صيانة',
        'latintitle': 'Maintenance Alert',
        'body': 'يرجى مراجعة مواعيد العمل',
        'touserid': '4',
        'tousertype': '4',
        'isviewed': 'false',
        'date': '2026-09-27T12:00:00Z',
      };

      final model = ReceiveNotificationModel.fromJson(payload);

      expect(model.id, equals(505));
      expect(model.title, equals('إشعار صيانة'));
      expect(model.latinTitle, equals('Maintenance Alert'));
      expect(model.description, equals('يرجى مراجعة مواعيد العمل'));
      expect(model.toUserId, equals(4));
      expect(model.toUserType, equals(4));
      expect(model.isViewed, isFalse);
    });

    test('ReceiveNotificationParser handles both FCM flat payload and nested SignalR wrapper', () {
      final parser = ReceiveNotificationParser();

      // FCM flat
      final fcmPayload = {
        'id': 606,
        'title': 'FCM Title',
        'description': 'FCM Body',
        'userId': 7,
        'userType': 4,
      };
      final fcmModel = parser.parse([fcmPayload]);
      expect(fcmModel, isNotNull);
      expect(fcmModel!.id, equals(606));
      expect(fcmModel.title, equals('FCM Title'));
      expect(parser.getUserId([fcmPayload]), equals(7));
      expect(parser.getUserType([fcmPayload]), equals(4));

      // SignalR nested
      final signalRPayload = {
        'userId': 7,
        'userType': 4,
        'data': {
          'data': {
            'notification': jsonEncode({
              'ID': 707,
              'TITLE': 'SignalR Title',
              'DESCRIPTION': 'SignalR Body',
              'TOUSERID': 7,
              'TOUSERTYPE': 4,
            }),
          },
        },
      };
      final sigModel = parser.parse([signalRPayload]);
      expect(sigModel, isNotNull);
      expect(sigModel!.id, equals(707));
      expect(sigModel.title, equals('SignalR Title'));
    });

    test('ReceiveMessageNotificationModel parses chat messages from FCM', () {
      final fcmChatPayload = {
        'type': 'ReceiveMessage',
        'fromuser': '55',
        'fromUserName': 'Khaled Client',
        'message': 'السلام عليكم، أين طلبي؟',
        'touser': '12',
        'tousertype': '4',
        'orderId': '101',
      };

      final parser = ReceiveMessageParser();
      final model = parser.parse([fcmChatPayload]);

      expect(model, isNotNull);
      expect(model!.userId, equals(12));
      expect(model.userType, equals(4));
      expect(model.data?.data?.message, equals('السلام عليكم، أين طلبي؟'));
      expect(model.data?.data?.fromUserName, equals('Khaled Client'));
      expect(model.data?.data?.orderId, equals('101'));
    });

    test('GetUserNotificationResponse parses ASP.NET Core PaginatedResult with uppercase keys', () {
      final backendResponse = {
        "Data": {
          "Data": [
            {
              "ID": 88,
              "TITLE": "طلب جديد رقم 88",
              "LATINTITLE": "New Order #88",
              "DESCRIPTION": "تفاصيل طلب الصيانة",
              "LATINDESC": "Maintenance order details",
              "TOUSERID": 12,
              "TOUSERTYPE": 4,
              "FROMUSERID": 0,
              "FROMUSERTYPE": 0,
              "ISVIEWED": false,
              "DATE": "2026-09-28T10:30:00.0000000Z",
            },
            {
              "ID": 89,
              "TITLE": "رسالة جديدة من العميل",
              "LATINTITLE": "New Chat Message",
              "DESCRIPTION": "مرحبا، هل الطلب جاهز؟",
              "LATINDESC": "Hello, is the order ready?",
              "TOUSERID": 12,
              "TOUSERTYPE": 4,
              "FROMUSERID": 5,
              "FROMUSERTYPE": 1,
              "ISVIEWED": true,
              "DATE": "2026-09-28T10:35:00.0000000Z",
            }
          ],
          "PageCount": 2,
          "TotalCount": 15,
          "CurrentPage": 1,
        },
        "Success": true,
      };

      final response = GetUserNotificationResponse.fromJson(backendResponse);

      expect(response.totalCount, equals(15));
      expect(response.pageCount, equals(2));
      expect(response.currentPage, equals(1));
      expect(response.data.length, equals(2));

      final first = response.data[0];
      expect(first.id, equals(88));
      expect(first.title, equals("طلب جديد رقم 88"));
      expect(first.latinTitle, equals("New Order #88"));
      expect(first.description, equals("تفاصيل طلب الصيانة"));
      expect(first.toUserId, equals(12));
      expect(first.toUserType, equals(4));
      expect(first.isViewed, equals(false));
      expect(first.date, isNotNull);
      expect(first.isOrderRelated, isTrue);
      expect(first.isChatRelated, isFalse);

      final second = response.data[1];
      expect(second.id, equals(89));
      expect(second.title, equals("رسالة جديدة من العميل"));
      expect(second.isViewed, equals(true));
      expect(second.isChatRelated, isTrue);
    });

    test('ReceiveNotificationParser handles broadcast notification without userType or userType 0', () {
      final broadcastPayload = {
        'type': 'GeneralNotification',
        'title': 'إشعار صيانة النظام',
        'body': 'سيتم إجراء صيانة للنظام الليلة',
        // userType is omitted or null
      };

      final parser = ReceiveNotificationParser();
      final model = parser.parse([broadcastPayload]);

      expect(model, isNotNull);
      expect(parser.getUserType([broadcastPayload]), isNull);
      expect(parser.getUserId([broadcastPayload]), isNull);

      final zeroUserTypePayload = {
        'type': 'GeneralNotification',
        'title': 'تنبيه عام',
        'body': 'تنبيه لجميع المستخدمين',
        'userType': '0',
      };
      expect(parser.getUserType([zeroUserTypePayload]), equals(0));
    });
  });
}
