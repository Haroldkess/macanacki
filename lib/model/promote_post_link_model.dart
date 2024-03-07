// To parse this JSON data, do
//
//     final dethroneModel = dethroneModelFromJson(jsonString);

import 'dart:convert';

PromoteLink promoteLinkModelFromJson(String str) =>
    PromoteLink.fromJson(json.decode(str));

String promoteLinkModelToJson(PromoteLink data) => json.encode(data.toJson());

class PromoteLink {
  bool? status;
  String? message;
  String? paymentLink;

  PromoteLink({
    this.status,
    this.message,
    this.paymentLink,
  });

  factory PromoteLink.fromJson(Map<String, dynamic> json) => PromoteLink(
        status: json["status"],
        message: json["message"],
        paymentLink: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": paymentLink,
      };
}
