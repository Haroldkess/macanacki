// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<NotifyData>? data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<NotifyData>.from(
                json["data"]!.map((x) => NotifyData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class NotifyData {
  NotifyData({
    this.id,
    this.userId,
    this.title,
    this.type,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.picture,
    this.username,
  });

  int? id;
  int? userId;
  String? title;
  String? type;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? picture;
  String? username;

  factory NotifyData.fromJson(Map<String, dynamic> json) => NotifyData(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        type: json["type"],
        body: json["body"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        picture: json["picture"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "type": type,
        "body": body,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "picture": picture,
        "username": username,
      };
}
