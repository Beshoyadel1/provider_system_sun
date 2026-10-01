import 'readable_api_text.dart';

class ServiceRequestModel {
  const ServiceRequestModel({
    required this.id,
    required this.price,
    required this.notes,
    required this.appointment,
    required this.date,
    required this.lat,
    required this.long,
    required this.offersCount,
    required this.hasMyOffer,
    required this.isRefused,
    required this.user,
    required this.service,
    required this.car,
    this.offers = const [],
  });

  final int id;
  final double price;
  final String notes;
  final DateTime? appointment;
  final DateTime? date;
  final double? lat;
  final double? long;
  final int offersCount;
  final bool hasMyOffer;
  final bool isRefused;
  final ServiceRequestUser user;
  final ServiceRequestService service;
  final ServiceRequestCar car;
  final List<ServiceRequestOffer> offers;

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: _asInt(json['id']),
      price: _asDouble(json['price']),
      notes: readableApiText(json['notes']),
      appointment: _asDate(json['appointment']),
      date: _asDate(json['date']),
      lat: _asNullableDouble(json['lat']),
      long: _asNullableDouble(json['long']),
      offersCount: _asInt(json['offersCount']),
      hasMyOffer: _asBool(json['hasMyOffer']),
      isRefused: _asBool(json['isRefused']),
      user: ServiceRequestUser.fromJson(_asMap(json['user'])),
      service: ServiceRequestService.fromJson(_asMap(json['service'])),
      car: ServiceRequestCar.fromJson(_asMap(json['car'])),
      offers: (json['offers'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((item) => ServiceRequestOffer.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList(growable: false),
    );
  }

  ServiceRequestModel copyWith({
    bool? hasMyOffer,
    bool? isRefused,
    int? offersCount,
    List<ServiceRequestOffer>? offers,
  }) {
    return ServiceRequestModel(
      id: id,
      price: price,
      notes: notes,
      appointment: appointment,
      date: date,
      lat: lat,
      long: long,
      offersCount: offersCount ?? this.offersCount,
      hasMyOffer: hasMyOffer ?? this.hasMyOffer,
      isRefused: isRefused ?? this.isRefused,
      user: user,
      service: service,
      car: car,
      offers: offers ?? this.offers,
    );
  }
}

class ServiceRequestUser {
  const ServiceRequestUser({
    required this.id,
    required this.userType,
    required this.name,
    required this.phone,
    required this.email,
    this.image,
  });

  final int id;
  final int userType;
  final String name;
  final String phone;
  final String email;
  final String? image;

  factory ServiceRequestUser.fromJson(Map<String, dynamic> json) {
    return ServiceRequestUser(
      id: _asInt(json['userId']),
      userType: _asInt(json['userType']),
      name: readableApiText(json['userName']),
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }
}

class ServiceRequestService {
  const ServiceRequestService({
    required this.id,
    required this.name,
    required this.latinName,
    this.image,
  });

  final int id;
  final String name;
  final String latinName;
  final String? image;

  factory ServiceRequestService.fromJson(Map<String, dynamic> json) {
    return ServiceRequestService(
      id: _asInt(json['id']),
      name: readableApiText(json['name']),
      latinName: readableApiText(json['latinName'] ?? json['latinname']),
      image: json['image']?.toString(),
    );
  }
}

class ServiceRequestCar {
  const ServiceRequestCar({
    required this.id,
    required this.name,
    required this.plateNo,
    this.brandId,
    this.brandName = '',
    this.brandLatinName = '',
    this.modelId,
    this.chassisNo = '',
    this.image,
  });

  final int id;
  final String name;
  final String plateNo;
  final int? brandId;
  final String brandName;
  final String brandLatinName;
  final int? modelId;
  final String chassisNo;
  final String? image;

  factory ServiceRequestCar.fromJson(Map<String, dynamic> json) {
    return ServiceRequestCar(
      id: _asInt(json['id']),
      name: readableApiText(json['modelName'] ?? json['name']),
      plateNo: readableApiText(json['plateNo']),
      brandId: _asNullableInt(json['brandId']),
      brandName: readableApiText(json['brandName']),
      brandLatinName: readableApiText(json['brandLatinName']),
      modelId: _asNullableInt(json['modelId']),
      chassisNo: json['chassisNo']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }
}

class ServiceRequestOffer {
  const ServiceRequestOffer({
    required this.id,
    required this.serviceRequestId,
    required this.status,
    required this.date,
    required this.cost,
    required this.price,
    required this.provider,
    required this.branch,
    required this.employee,
    required this.service,
  });

  final int id;
  final int serviceRequestId;
  final int status;
  final DateTime? date;
  final double cost;
  final ServiceOfferPrice price;
  final ServiceOfferProvider provider;
  final ServiceOfferBranch branch;
  final ServiceOfferEmployee employee;
  final ServiceRequestService service;

  factory ServiceRequestOffer.fromJson(Map<String, dynamic> json) {
    return ServiceRequestOffer(
      id: _asInt(json['id']),
      serviceRequestId: _asInt(json['serviceRequestId']),
      status: _asInt(json['offerStatus']),
      date: _asDate(json['date']),
      cost: _asDouble(json['cost']),
      price: ServiceOfferPrice.fromJson(_asMap(json['price'])),
      provider: ServiceOfferProvider.fromJson(_asMap(json['provider'])),
      branch: ServiceOfferBranch.fromJson(_asMap(json['branch'])),
      employee: ServiceOfferEmployee.fromJson(_asMap(json['employee'])),
      service: ServiceRequestService.fromJson(_asMap(json['service'])),
    );
  }
}

class ServiceOfferPrice {
  const ServiceOfferPrice({
    required this.price,
    required this.cost,
    required this.taxPercentage,
    required this.taxAmount,
    required this.totalPrice,
  });

  final double price;
  final double cost;
  final double taxPercentage;
  final double taxAmount;
  final double totalPrice;

  factory ServiceOfferPrice.fromJson(Map<String, dynamic> json) {
    return ServiceOfferPrice(
      price: _asDouble(json['price']),
      cost: _asDouble(json['cost']),
      taxPercentage: _asDouble(json['taxPercentage']),
      taxAmount: _asDouble(json['taxAmount']),
      totalPrice: _asDouble(json['totalPrice']),
    );
  }
}

class ServiceOfferProvider {
  const ServiceOfferProvider({required this.id, required this.name});
  final int id;
  final String name;

  factory ServiceOfferProvider.fromJson(Map<String, dynamic> json) {
    return ServiceOfferProvider(
      id: _asInt(json['id']),
      name: readableApiText(json['name']),
    );
  }
}

class ServiceOfferBranch {
  const ServiceOfferBranch({
    required this.id,
    required this.name,
    required this.latinName,
  });
  final int id;
  final String name;
  final String latinName;

  factory ServiceOfferBranch.fromJson(Map<String, dynamic> json) {
    return ServiceOfferBranch(
      id: _asInt(json['id']),
      name: readableApiText(json['name']),
      latinName: readableApiText(json['latinName']),
    );
  }
}

class ServiceOfferEmployee {
  const ServiceOfferEmployee({
    required this.id,
    required this.name,
    required this.job,
  });
  final int id;
  final String name;
  final String job;

  factory ServiceOfferEmployee.fromJson(Map<String, dynamic> json) {
    return ServiceOfferEmployee(
      id: _asInt(json['id']),
      name: readableApiText(json['name']),
      job: readableApiText(json['job']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
}

int _asInt(dynamic value) => _asNullableInt(value) ?? 0;

int? _asNullableInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

double _asDouble(dynamic value) => _asNullableDouble(value) ?? 0;

double? _asNullableDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  return value?.toString().toLowerCase() == 'true';
}

DateTime? _asDate(dynamic value) => DateTime.tryParse(value?.toString() ?? '');
