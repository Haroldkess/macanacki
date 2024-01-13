// To parse this JSON data, do
//
//     final buyFollowerModel = buyFollowerModelFromJson(jsonString);

import 'dart:convert';

BuyFollowerModel buyFollowerModelFromJson(String str) =>
    BuyFollowerModel.fromJson(json.decode(str));

String buyFollowerModelToJson(BuyFollowerModel data) =>
    json.encode(data.toJson());

class BuyFollowerModel {
  bool? status;
  String? message;
  Data? data;

  BuyFollowerModel({
    this.status,
    this.message,
    this.data,
  });

  factory BuyFollowerModel.fromJson(Map<String, dynamic> json) =>
      BuyFollowerModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  dynamic userId;
  dynamic initialFollowers;
  dynamic followTarget;
  dynamic followCount;
  dynamic diamondValue;
  dynamic status;
  DateTime? updatedAt;
  DateTime? createdAt;
  dynamic id;

  Data({
    this.userId,
    this.initialFollowers,
    this.followTarget,
    this.followCount,
    this.diamondValue,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        initialFollowers: json["initial_followers"],
        followTarget: json["follow_target"],
        followCount: json["follow_count"],
        diamondValue: json["diamond_value"],
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "initial_followers": initialFollowers,
        "follow_target": followTarget,
        "follow_count": followCount,
        "diamond_value": diamondValue,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
