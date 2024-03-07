// To parse this JSON data, do
//
//     final dethroneModel = dethroneModelFromJson(jsonString);

import 'dart:convert';

DethroneModel dethroneModelFromJson(String str) =>
    DethroneModel.fromJson(json.decode(str));

String dethroneModelToJson(DethroneModel data) => json.encode(data.toJson());

class DethroneModel {
  bool? status;
  String? message;
  String? paymentLink;

  DethroneModel({
    this.status,
    this.message,
    this.paymentLink,
  });

  factory DethroneModel.fromJson(Map<String, dynamic> json) => DethroneModel(
        status: json["status"],
        message: json["message"],
        paymentLink: json["payment_link"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "payment_link": paymentLink,
      };
}
