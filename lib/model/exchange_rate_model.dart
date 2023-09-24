// To parse this JSON data, do
//
//     final exchangeRateModel = exchangeRateModelFromJson(jsonString);

import 'dart:convert';

ExchangeRateModel exchangeRateModelFromJson(String str) => ExchangeRateModel.fromJson(json.decode(str));

String exchangeRateModelToJson(ExchangeRateModel data) => json.encode(data.toJson());

class ExchangeRateModel {
    bool? status;
    String? message;
     dynamic data;

    ExchangeRateModel({
        this.status,
        this.message,
        this.data,
    });

    factory ExchangeRateModel.fromJson(Map<String, dynamic> json) => ExchangeRateModel(
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
