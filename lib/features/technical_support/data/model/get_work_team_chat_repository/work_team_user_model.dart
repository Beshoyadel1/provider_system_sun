import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class WorkTeamUserModel {
  final int userId;
  final int userType;
  final String name;
  final String latinName;
  final String jobName;
  final String latinJobName;
  final Uint8List? image;

  WorkTeamUserModel({
    required this.userId,
    required this.userType,
    required this.name,
    required this.latinName,
    required this.jobName,
    required this.latinJobName,
    this.image,
  });

  factory WorkTeamUserModel.fromJson(Map<String, dynamic> json) {
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
    final name = (map['name'] ?? map['username'] ?? "").toString();
    final latinName = (map['latinname'] ?? map['name'] ?? "").toString();
    final jobName = (map['jobname'] ?? "").toString();
    final latinJobName = (map['latinjobname'] ?? map['jobname'] ?? "").toString();
    final image = parseImage(map['image']);

    return WorkTeamUserModel(
      userId: userId,
      userType: userType,
      name: name,
      latinName: latinName,
      jobName: jobName,
      latinJobName: latinJobName,
      image: image,
    );
  }

  bool _isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }

  String getName(BuildContext context) {
    return _isEnglish(context)
        ? (latinName.isNotEmpty ? latinName : name)
        : name;
  }

  String getJobName(BuildContext context) {
    return _isEnglish(context)
        ? (latinJobName.isNotEmpty ? latinJobName : jobName)
        : jobName;
  }
}