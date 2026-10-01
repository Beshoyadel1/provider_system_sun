import '../../../service_requests/data/model/service_request_model.dart';

class NewServiceRequestNotificationModel {
  const NewServiceRequestNotificationModel({
    this.userId,
    required this.userType,
    required this.title,
    required this.body,
    required this.serviceId,
    this.item,
  });

  final int? userId;
  final int userType;
  final String title;
  final String body;
  final int serviceId;
  final ServiceRequestModel? item;
}
