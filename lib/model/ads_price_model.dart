// To parse this JSON data, do
//
//     final adsPriceModel = adsPriceModelFromJson(jsonString);

import 'dart:convert';

AdsPriceModel adsPriceModelFromJson(String str) =>
    AdsPriceModel.fromJson(json.decode(str));

String adsPriceModelToJson(AdsPriceModel data) => json.encode(data.toJson());

class AdsPriceModel {
  bool? status;
  String? message;
  List<AdsData>? data;

  AdsPriceModel({
    this.status,
    this.message,
    this.data,
  });

  factory AdsPriceModel.fromJson(Map<String, dynamic> json) => AdsPriceModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<AdsData>.from(json["data"]!.map((x) => AdsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AdsData {
  int? id;
  dynamic price;
  String? reach;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;

  AdsData({
    this.id,
    this.price,
    this.reach,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AdsData.fromJson(Map<String, dynamic> json) => AdsData(
        id: json["id"],
        price: json["price"],
        reach: json["reach"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "reach": reach,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class SendAdModel {
  String planId, postId, duration, country;

  SendAdModel(
      {required this.planId,
      required this.postId,
      required this.duration,
      required this.country});
}
