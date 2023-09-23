// To parse this JSON data, do
//
//     final giftBalanceModel = giftBalanceModelFromJson(jsonString);

import 'dart:convert';

GiftBalanceModel giftBalanceModelFromJson(String str) => GiftBalanceModel.fromJson(json.decode(str));

String giftBalanceModelToJson(GiftBalanceModel data) => json.encode(data.toJson());

class GiftBalanceModel {
    bool? status;
    String? message;
    dynamic data;

    GiftBalanceModel({
        this.status,
        this.message,
        this.data,
    });

    factory GiftBalanceModel.fromJson(Map<String, dynamic> json) => GiftBalanceModel(
        status: json["status"],
        message: json["message"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
    };
}
