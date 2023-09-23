// To parse this JSON data, do
//
//     final userBalanceModel = userBalanceModelFromJson(jsonString);

import 'dart:convert';

UserBalanceModel userBalanceModelFromJson(String str) => UserBalanceModel.fromJson(json.decode(str));

String userBalanceModelToJson(UserBalanceModel data) => json.encode(data.toJson());

class UserBalanceModel {
    bool? status;
    String? message;
    dynamic data;

    UserBalanceModel({
        this.status,
        this.message,
        this.data,
    });

    factory UserBalanceModel.fromJson(Map<String, dynamic> json) => UserBalanceModel(
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
